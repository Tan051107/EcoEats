import * as functions from 'firebase-functions'
import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import Joi from 'joi';

export const addUsersFavourite=functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed");
    }

    const database = admin.firestore();

    const userId = request.auth.uid;

    const userRef = database.collection("users").doc(userId);

    const schema = Joi.object({
        "recipe_id":Joi.string().required()
    })

    const {error,value} = schema.validate(request.data);

    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)       
    }

    const {recipe_id} = value;

    try{
        const favouriteRecipeDocRef = userRef.collection("favourites").doc(recipe_id)
        const favouriteRecipeDocSnapshot = await favouriteRecipeDocRef.get();
        if(favouriteRecipeDocSnapshot.exists){
            await favouriteRecipeDocRef.delete()
            return{
                success:true,
                message:"Successfully removed recipe from favourite"
            }
        }
        await favouriteRecipeDocRef.set({
            recipe_id:recipe_id,
            saved_at:admin.firestore.FieldValue.serverTimestamp()
        })

        return{
            success:true,
            message:"Successfully added recipe to favourite"
        }


    }
    catch(err){
        throw new functions.https.HttpsError("internal" , `Failed to get user favourites:${err.message}`)
    }
})