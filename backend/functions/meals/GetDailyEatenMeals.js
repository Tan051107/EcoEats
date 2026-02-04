import { getDailyEatenMealsHelper } from "./GetDailyEatenMealsHelper.js";
import * as functions from 'firebase-functions'

export const getDailyEatenMeals = functions.https.onCall(async(_,context)=>{
    if(!context.auth){
            throw new functions.https.HttpsError('unauthenticated' , "Please login to proceeed.")
        }
    
    const today  = new Date ()
    const userId = context.auth.uid;

    try{
        const userDailyEatenMeals = await getDailyEatenMealsHelper(userId ,today);

        return userDailyEatenMeals;
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }

}) 