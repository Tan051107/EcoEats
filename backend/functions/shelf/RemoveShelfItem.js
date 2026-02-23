import * as functions from 'firebase-functions'
import admin from '../utils/firebase-admin.cjs';
// const admin = adminModule.default ?? adminModule; 
import Joi from 'joi';

const schema = Joi.object({
    item_id:Joi.string().required()
})

export const removeShelfItem = functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed");
    }

    const userId = request.auth.uid;

    const {error,value} = schema.validate(request.data);

    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)       
    }

    const {item_id} = value; 

    const database = admin.firestore();

    const userRef = database.collection("users").doc(userId);

    const shelfItemRef = userRef.collection("shelf").doc(item_id);

    try{
        const shelfItemSnapshot = await shelfItemRef.get();

        if(!shelfItemSnapshot.exists){
            throw new functions.https.HttpsError("not-found" , "Shelf item to remove not found")
        }

        await shelfItemRef.delete();

        return{
            success:true,
            message:"Shelf item successfully removed from shelf."
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , `Failed to removed shelf item from shelf:${err.message}`)
    }
})