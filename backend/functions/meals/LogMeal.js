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
    healthy_score:Joi.number().min(0).max(100),
    comment:Joi.string()   
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

    const database = admin.firestore()

    const userRef = database.collection("users").doc(userId);

    const mealDocRef = userRef.collection("meals").doc();

    const {calories,protein,carbs,fat , ...mealData} = value;
    const today = new Date();
    const formattedDate = format(today,"yyyy-MM-dd")
    const formattedData = {
        date:formattedDate,
        nutrition:{
            calories_kcal:calories,
            protein_g:protein,
            carbs_g:carbs,
            fat_g:fat
        },
        ...mealData,
        created_at:admin.firestore.FieldValue.serverTimestamp(),
        updated_at:admin.firestore.FieldValue.serverTimestamp(),
    }

    try{
        await mealDocRef.set(formattedData)
        return{
            success:true,
            message:"Successfully added new meal",
            data:formattedData
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , `Failed to add new meal: ${err.message}`)
    }
})