import * as functions from 'firebase-functions'
import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import Joi from 'joi';

const schema = Joi.object({
    quantity:Joi.number().min(0).required(),
    item_id: Joi.string().required()
})

export const updateShelfItem = functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed");
    }

    const userId = request.auth.uid;

    const {error,value} = schema.validate(request.data)

    
    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)       
    }

    const {quantity,item_id} = value;

    const database = admin.firestore();

    const userRef = database.collection("users").doc(userId);

    const shelfItemRef = userRef.collection("shelf").doc(item_id);

    try{
        const shelfItemSnapshot = await shelfItemRef.get();


        if(!shelfItemSnapshot.exists){
            throw new functions.https.HttpsError("not-found" , "Item to update quantity not found.")
        }

        if(quantity <=0){
            await shelfItemRef.delete();
            return{
                success:true,
                message:"Quantity updated to 0. Item is removed from shelf"
            }
        }

        await shelfItemRef.set({
            quantity:quantity,
            updated_at:admin.firestore.FieldValue.serverTimestamp()
        },{merge:true})

        return{
            success:true,
            message:`Quantity of item is updated to ${quantity}.`
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal",`Failed to update shelf item quantity:${err.message}`)
    }

})