import { getDailySummaryHelper } from './GetDailySummaryHelper.js'
import {getAllUsersData} from '../utils/GetAllUsersData.js'
import * as functions from 'firebase-functions'
import{getUserDailyCalorieIntake} from '../utils/GetUserDailyCalorieIntake.js'

export const getDailySummary = functions.https.onCall(async(data)=>{
    if(!data.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed.")
    }

    try{
        const userId = data.auth.uid;

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
            success:true,
            message:"Successfully retrieved user's daily summary",
            data:{
                ...userDailySummary,
                remaining_calories:remainingCalories <= 0 ? 0 : remainingCalories,
                daily_calorie_intake:userDailyCalorieIntake
            }
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }
})