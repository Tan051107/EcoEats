import * as functions from 'firebase-functions';
import {format} from 'date-fns'
import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import Joi from 'joi';

const schema = Joi.object({
    name:Joi.string().required(),
    calories:Joi.number().min(0).required(),
    protein:Joi.number().min(0).required(),
    carbs:Joi.number().min(0).required(),
    fat:Joi.number().min(0).required(),
    healthy_score:Joi.string().valid("High","Medium","Low"),
    comment:Joi.string(),
    meal_id:Joi.string(),
    image_urls:Joi.array().items(Joi.string()).invalid(null),
    packaging_materials:Joi.array().items(Joi.object())
})

export const logMeal = functions.https.onCall(async(request)=>{

    if(!request.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed");
    }

    const userId = request.auth.uid;

    const {error,value} = schema.validate(request.data);

    if(error){
        throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)       
    }


    const {calories,protein,carbs,fat, meal_id ,...mealData} = value;

    const formattedData = {
        nutrition:{
            calories_kcal:calories,
            protein_g:protein,
            carbs_g:carbs,
            fat_g:fat
        },
        ...mealData,
        updated_at:admin.firestore.FieldValue.serverTimestamp(),
    }

    const database = admin.firestore()

    const userRef = database.collection("users").doc(userId);

    let userMealDocRef = userRef.collection("meals");

    if(meal_id){
        userMealDocRef = userMealDocRef.doc(meal_id)
        const userMealDocSnapshot = await userMealDocRef.get();
        if(!userMealDocSnapshot.exists){
            throw new functions.https.HttpsError("not-found" , "Meal not found.");
        }
    }
    else{
        userMealDocRef =  userMealDocRef.doc()
        const today = new Date();
        const formattedDate = format(today,"yyyy-MM-dd")
        formattedData.date = formattedDate;
        formattedData.created_at = admin.firestore.FieldValue.serverTimestamp()
    }

    try{
        await userMealDocRef.set(formattedData,{merge:true})
        const addedData = await userMealDocRef.get();
        return{
            success:true,
            message:`Successfully ${meal_id ? "updated" : "added"} new meal`,
            meal_added:{
                meal_id:addedData.id,
                ...formattedData
            }
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , `Failed to add new meal: ${err.message}`)
    }
})