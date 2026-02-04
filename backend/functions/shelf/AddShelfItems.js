import Joi from 'joi'
import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import * as functions from 'firebase-functions'
import { toFirestoreTimestamp } from '../utils/ToFirestoreTimestamp.js';


const database = admin.firestore();

const shelfItemSchema =Joi.object({
    item_name:Joi.string().required(),
    category:Joi.string().valid("fresh produce" , "packaged food" , "packaged beverage").required(),
    quantity:Joi.number().min(1).required(),
    expiry_date:Joi.string().pattern(/^\d{4}-\d{2}-\d{2}$/).required(),
    calories_kcal:Joi.number().required(),
    protein_g:Joi.number().required(),
    fat_g:Joi.number().required(),
    carbs_g:Joi.number().required(),
    image_urls:Joi.array().items(Joi.string().uri()).invalid(null)
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

    const {calories_kcal,protein_g,carbs_g,fat_g ,expiry_date, ...itemData} = value

    try{
        const userRef = database.collection('users').doc(userId)
        const itemRef = userRef.collection('shelf').doc();

        await itemRef.set({
            ...itemData,
            expiry_date:toFirestoreTimestamp(expiry_date),
            nutrition:{
                calories_kcal:calories_kcal,
                protein_g:protein_g,
                carbs_g:carbs_g,
                fat_g:fat_g
            },
            is_packaged:itemData.category !== "fresh produce",
            created_at: admin.firestore.FieldValue.serverTimestamp(),
            updated_at: admin.firestore.FieldValue.serverTimestamp()
        })

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



