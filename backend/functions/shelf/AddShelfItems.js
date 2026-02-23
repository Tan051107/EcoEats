import Joi from 'joi'
import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import * as functions from 'firebase-functions'
import { toFirestoreTimestamp } from '../utils/ToFirestoreTimestamp.js';
import { storePackagedFoodNutrition } from '../ai/StorePackagedFoodNutrition.js';
import {differenceInDays, format} from 'date-fns'


const database = admin.firestore();

const shelfItemSchema =Joi.object({
    name:Joi.string().required(),
    category:Joi.string().valid("fresh produce" , "packaged food" , "packaged beverage").required(),
    quantity:Joi.number().min(1).required(),
    expiry_date:Joi.string().pattern(/^\d{4}-\d{2}-\d{2}$/).required(),
    calories_kcal:Joi.number().required(),
    protein_g:Joi.number().required(),
    fat_g:Joi.number().required(),
    carbs_g:Joi.number().required(),
    image_urls:Joi.array().items(Joi.string()).invalid(null),
    barcode:Joi.string(),
})

export const addShelfItem = functions.https.onCall(async(request)=>{
    console.log("Received Data:",request.data)
    if(!request.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed.")
    }

    const userId = request.auth.uid;

    const {error , value} = shelfItemSchema.validate(request.data)

    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)       
    }

    let {name,category,barcode,calories_kcal,protein_g,carbs_g,fat_g ,expiry_date, ...itemData} = value

    const [expiryYear,expiryMonth,expiryDay] = expiry_date.split("-").map(Number);
    const today = new Date()
    const expiryDate = new Date(expiryYear,expiryMonth-1,expiryDay);

    const estimated_shelf_life = differenceInDays(expiryDate,today);

    if(estimated_shelf_life < 1){
        throw new functions.https.HttpsError('invalid-argument' , "Item has expired.")
    }

    try{
        const userRef = database.collection('users').doc(userId)
        const itemRef = userRef.collection('shelf').doc();

        const nutrition = {
            calories_kcal:calories_kcal,
            protein_g:protein_g,
            carbs_g:carbs_g,
            fat_g:fat_g
        }

        await itemRef.set({
            ...itemData,
            name:name,
            category:category,
            expiry_date:toFirestoreTimestamp(expiry_date),
            nutrition:nutrition,
            is_packaged:category !== "fresh produce",
            created_at: admin.firestore.FieldValue.serverTimestamp(),
            updated_at: admin.firestore.FieldValue.serverTimestamp(),
            estimated_shelf_life:estimated_shelf_life
        })

        if(barcode!== undefined){
            const itemData = {
                name:name,
                category:category,
                nutrition:nutrition
            }
            await storePackagedFoodNutrition(barcode,itemData)
        }

        const snap = await itemRef.get()

        return{
            success:true,
            message:`Successfully added a new grocery item in user ${userId} shelf.`,
            itemAdded:{itemId:itemRef.id , ...snap.data()}
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }
})



