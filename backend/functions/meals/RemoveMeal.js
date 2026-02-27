import admin from '../utils/firebase-admin.cjs'
import * as functions from 'firebase-functions'
import Joi from 'joi'

const schema = Joi.object({
    meal_id:Joi.string().required()
})

export const removeMeal = functions.https.onCall(async(request)=>{

    if(!request.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed")
    }

    const {error,value} = schema.validate(request.data)

    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)       
    }

    const {meal_id} = value;

    const userId = request.auth.uid;
    const database = admin.firestore()

    const userRef = database.collection("users").doc(userId);
    
    try{
        const userMealRef = userRef.collection("meals").doc(meal_id)
        const userMealSnapshot = await userMealRef.get()
        if(!userMealSnapshot.exists){
            throw new functions.https.HttpsError("not-found" , "Meal not found.")
        }
        await userMealRef.delete();

        return{
            success:true,
            message:"Successfully deleted meal"
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , `Failed to delete meal:${err.message}`)
    }
})