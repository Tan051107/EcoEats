import {startOfWeek,subWeeks,addDays} from 'date-fns';
import {getDailySummaryHelper} from './GetDailySummaryHelper.js'
import {getUserDailyCalorieIntake} from '../utils/GetUserDailyCalorieIntake.js'
import { getAllUsersData } from '../utils/GetAllUsersData.js';
import * as functions from 'firebase-functions'
import { getWeeklySummaryRecommendations } from '../ai/GetWeeklySummaryRecommendation.js';

export const getWeeklySummary = functions.https.onCall(async(_,context)=>{

    if(!context.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed")
    }

    const userId = context.auth.uid;

    try{
        const allUsers = await getAllUsersData();

        const userData = allUsers.data.find(user=>user.userId === userId)

        if(!userData){
            throw new functions.https.HttpsError('not-found' , "User not found.")
        }

        const today = new Date()

        const startOfThisWeek = startOfWeek(today , {weekStartsOn:1})

        const startOfLastWeek = subWeeks(startOfThisWeek,1)
        const lastWeekDates = Array.from({length:7} , (_,noOfDaysToAdd)=>addDays(startOfLastWeek,noOfDaysToAdd))

        let totalWeeklyCalories =0;
        let totalWeeklyProtein =0;
        let totalWeeklyFat = 0;
        let totalWeeklyCarbs =0

        const {goal,activity_level, bmr ,weight, height ,age, gender,diet_type} = userData;

        const userDailyCalorieIntake = getUserDailyCalorieIntake(activity_level,goal,bmr)

        const weeklySummary = await Promise.all(
            lastWeekDates.map(date=>getDailySummaryHelper(userId,date))
        )


        for(const summary of weeklySummary){
            totalWeeklyCalories+=summary.total_calories_kcal,
            totalWeeklyFat+=summary.total_fat_g,
            totalWeeklyProtein+=summary.total_protein_g,
            totalWeeklyCarbs+=summary.total_carbs_g,
            summary.is_over_target = summary.total_calories_kcal > userDailyCalorieIntake
        }

        const averageDailyCalories = totalWeeklyCalories/7;
        const averageDailyProtein = totalWeeklyProtein/7;
        const averageDailyFat = totalWeeklyFat/7
        const averageDailyCarbs = totalWeeklyCarbs/7

        const result = {
            each_day_summary:weeklySummary,
            average_daily_calories_kcal:averageDailyCalories,
            average_daily_protein_g:averageDailyProtein,
            average_daily_fat_g:averageDailyFat,
            average_daily_carbs_g:averageDailyCarbs,
            daily_calorie_intake_kcal:userDailyCalorieIntake
        }

        const recommendations = await getWeeklySummaryRecommendations(result,goal,activity_level,weight,height,age,gender)

        if(!recommendations.success){
            throw functions.https.HttpsError(recommendations.message)
        }

        result.recommendations = recommendations.data

        return{
            success:true,
            message:"Successfully returned weekly summary of user",
            data:result
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }
})
