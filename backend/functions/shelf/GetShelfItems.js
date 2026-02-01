import admin from '../utils/firebase-admin.cjs'
import Joi from 'joi'
import * as functions from 'firebase-functions'


export const getShelfItems = functions.https.onCall(async(data,context)=>{
    if(!context.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to get shelf items")
    }
    const {category} = data
    const userId = context.auth.uid;
    const database = admin.firestore()
    const schema = Joi.object({category:Joi.string().valid("fresh produce" , "packaged food" , "packaged beverage").required()})
    const{errors , value} = schema.validate(category)

    if(errors){
        throw new functions.https.HttpsError('invalid-argument',`Validation failed:${error.details.map(detail=>detail.message).join(",")}`)
    }
    try{
        const userSnapshot = database.collection('users').doc(userId)
        let query = userSnapshot.collection('shelf')

        if(category){
            query = query.where('category' , '==' ,category)
        }

        const shelfSnapshot = await query.get()

        const shelfItems = shelfSnapshot.docs.map(doc=>({
            shelfItemId:doc.id,
            ...doc.data()
        })) 

        return{
            success:true,
            message:`Successfully retrieved ${userId} shelf items`,
            data:shelfItems
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }

})

