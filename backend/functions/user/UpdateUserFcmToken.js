import * as functions from 'firebase-functions'
import adminModule from '../utils/firebase-admin.cjs';
import Joi from 'joi';
const admin = adminModule.default ?? adminModule; 


const schema = Joi.object({
  fcm_token:Joi.string().required(),
})

export const updateUserFcmToken = functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed")
    }

    const database = admin.firestore()

    const userId = request.auth.uid;

    const userRef = database.collection("users").doc(userId);

    const {error,value} = schema.validate(request.data)
    
    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)
    }

    const {fcm_token} = value

    try{
        await userRef.set({
            fcm_token:fcm_token,
            updated_at:admin.firestore.FieldValue.serverTimestamp()
        },{merge:true})
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }
})

