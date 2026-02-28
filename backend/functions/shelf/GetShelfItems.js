import admin from '../utils/firebase-admin.cjs'
import Joi from 'joi'
import * as functions from 'firebase-functions'
import {toZonedTime} from "date-fns-tz";
import {differenceInDays} from 'date-fns'


export const getShelfItems = functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed.")
    }

    const userId = request.auth.uid;
    const database = admin.firestore()
    const schema = Joi.object({category:Joi.string().valid("fresh produce" , "packaged food" , "packaged beverage").optional()})
    const{error,value} = schema.validate(request.data)

    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)
    }

    const {category} = value

    try{
        const userSnapshot = database.collection('users').doc(userId)
        let query = userSnapshot.collection('shelf')

        if(category !== undefined){
            query = query.where('category' , '==' ,category)
        }

        const shelfSnapshot = await query.get()

        const today = toZonedTime(new Date(), 'Asia/Kuala_Lumpur');
        const shelfItems = shelfSnapshot.docs
        .filter(doc => {
            const expiryDate = doc.data().expiry_date.toDate();
            const dateDifference = differenceInDays(expiryDate, today);
            return dateDifference >= 1;
        })
        .map(doc => {
            const expiryDate = doc.data().expiry_date.toDate();
            const formattedExpiryDate = expiryDate.toISOString().split('T')[0];

            return {
            item_id: doc.id,
            ...doc.data(),
            expiry_date: formattedExpiryDate
            };
        });

        return{
            success:true,
            category:category? category : "All",
            message:`Successfully retrieved ${userId} shelf items`,
            data:shelfItems
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }

})

