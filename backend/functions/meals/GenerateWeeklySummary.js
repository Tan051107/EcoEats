import {addDays, format} from 'date-fns';
import {getDailySummaryHelper} from './GetDailySummaryHelper.js'
import {getUserDailyCalorieIntake} from '../utils/GetUserDailyCalorieIntake.js'
import { getAllUsersData } from '../utils/GetAllUsersData.js';
import * as functions from 'firebase-functions'
import { getWeeklySummaryRecommendations } from '../ai/GetWeeklySummaryRecommendation.js';
import { addUserWeeklySummary } from './AddUserWeeklySummary.js';

export async function generateWeeklySummary(userId , startOfLastWeek){
        try{
        const allUsers = await getAllUsersData();

        const userData = allUsers.data.find(user=>user.userId === userId)

        if(!userData){
            throw new Error("Couldn't find user's data")
        }

        const lastWeekDates = Array.from({length:7} , (_,noOfDaysToAdd)=>addDays(startOfLastWeek,noOfDaysToAdd))

        let totalWeeklyCalories =0;
        let totalWeeklyProtein =0;
        let totalWeeklyFat = 0;
        let totalWeeklyCarbs =0
        let hasSummary = false;

        const {goal,activity_level, bmr ,weight, height ,age, gender,diet_type} = userData;

        const userDailyCalorieIntake = getUserDailyCalorieIntake(activity_level,goal,bmr)

        const weeklySummary = await Promise.all(
            lastWeekDates.map(date=>getDailySummaryHelper(userId,date))
        )


        for(const summary of weeklySummary){
            if(summary.total_calories_kcal > 0){
                hasSummary = true;
            }
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
        const formattedStartDate = format(startOfLastWeek, "yyyy-MMM-dd")
        const endDate = addDays(startOfLastWeek,6)
        const formattedEndDate = format(endDate, "yyyy-MMM-dd")

        const result = {
            start_date:formattedStartDate,
            end_date: formattedEndDate,
            each_day_summary:weeklySummary,
            average_daily_calories_kcal:Math.round(averageDailyCalories),
            average_daily_protein_g:Math.round(averageDailyProtein),
            average_daily_fat_g:Math.round(averageDailyFat),
            average_daily_carbs_g:Math.round(averageDailyCarbs),
            daily_calorie_intake_kcal:Math.round(userDailyCalorieIntake)
        }

        if(hasSummary){
            const recommendations = await getWeeklySummaryRecommendations(result,goal,activity_level,weight,height,age,gender,diet_type)

            if(!recommendations.success){
                throw functions.https.HttpsError(recommendations.message)
            }

            result.recommendations = recommendations.data
        }
        else{
            result.recommendations = [];
        }

        await addUserWeeklySummary(userId,result,startOfLastWeek)

        return{
            success:true,
            message:"Successfully returned weekly summary of user.Just generated and saved into database",
            data:result
        }
    }
    catch(err){
        throw new Error(`Failed to retrived user's weekly summary:${err.message}`)
    }
}

