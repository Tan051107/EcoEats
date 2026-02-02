import { getDailyEatenMealsHelper } from "./GetDailyEatenMealsHelper.js";
import * as functions from 'firebase-functions'

export const getDailyEatenMeals = functions.https.onCall(async(_,context)=>{
    try{
        if(!context.auth){
            throw new functions.https.HttpsError('unauthenticated' , "Please login to proceeed.")
        }

        const userId = context.auth.uid;

        const userDailyEatenMeals = await getDailyEatenMealsHelper(userId);

        if(!userDailyEatenMeals.success){
            throw new functions.https.HttpsError('internal' , userDailyEatenMeals.message)
        }

        return userDailyEatenMeals;
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }

}) 