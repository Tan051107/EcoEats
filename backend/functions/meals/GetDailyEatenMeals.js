import { getDailyEatenMealsHelper } from "./GetDailyEatenMealsHelper.js";
import * as functions from 'firebase-functions'

export const getDailyEatenMeals = functions.https.onCall(async(data)=>{
    if(!data.auth){
            throw new functions.https.HttpsError('unauthenticated' , "Please login to proceeed.")
        }
    
    const today  = new Date ()
    const userId = data.auth.uid;

    try{
        const userDailyEatenMeals = await getDailyEatenMealsHelper(userId ,today);

        return userDailyEatenMeals;
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }

}) 