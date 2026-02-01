import Joi from 'joi'
import admin from '../utils/firebase-admin.cjs'
import * as functions from 'firebase-functions'


const database = admin.firestore();

const shelfItemSchema =Joi.object({
    item_name:Joi.string().required(),
    category:Joi.string().valid("fresh produce" , "packaged food" , "packaged beverage").required(),
    quantity:Joi.number().min(1).required(),
    expiry_date:Joi.date().required(),
    calories_kcal:Joi.number().required(),
    protein_g:Joi.number().required(),
    fat_g:Joi.number().required(),
    carbs_g:Joi.number().required()
})

export const addShelfItem = functions.https.onCall(async(data,context)=>{
    if(context.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to add shelf items.")
    }

    const userId = context.auth.uid;
    const{ itemData} = data

    const {error , value} = shelfItemSchema.validate(itemData)

    if(error){
        throw new functions.https.HttpsError('invalid-argument',`Validation failed:${error.details.map(detail=>detail.message).join(",")}`)       
    }

    try{
        const userRef = database.collection('users').doc(userId)
        const shelfRef = userRef.collection('shelf').doc();

        await shelfRef.set({
            ...value,
            is_packaged:itemData.category !== "fresh produce",
            created_at: admin.firestore.FieldValue.serverTimestamp(),
            updated_at:admin.firestore.FieldValue.serverTimestamp()
        })

        return{
            success:true,
            message:`Successfully added a new grocery item in user ${userId} shelf`,
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }
})

