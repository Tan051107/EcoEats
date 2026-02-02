import { getDailySummaryHelper } from "./GetDailySummaryHelper";
import {getAllUsersData} from '../utils/GetAllUsersData.js'
import * as functions from 'firebase-functions'
import{getUserDailyCalorieIntake} from '../utils/GetUserDailyCalorieIntake.js'

export const getDailySummary = functions.https.onCall(async(_,context)=>{
    if(!context.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed.")
    }

    try{
        const userId = context.auth.uid;

        const today = new Date()

        const userDailySummary = await getDailySummaryHelper(userId , today)

        const allUsers = await getAllUsersData();

        const allUserData = allUsers.data;

        const userData = allUserData.find(user=>user.userId === userId)

        if(!userData){
            throw new functions.https.HttpsError("not-found" , "User not found.")
        }

        const {goal,activity_level, bmr} = userData;

        const userDailyCalorieIntake = getUserDailyCalorieIntake(activity_level,goal,bmr)
        
        const remainingCalories = userDailyCalorieIntake - userDailySummary.total_calories_kcal;

        return{
            ...userDailySummary,
            remaining_calories:remainingCalories,
            daily_calorie_intake:userDailyCalorieIntake
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }
})