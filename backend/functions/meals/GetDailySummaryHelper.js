import { getDailyEatenMealsHelper } from "./GetDailyEatenMealsHelper.js"
import { format } from "date-fns";

export async function getDailySummaryHelper(userId, date){

    try{
        const userDailyEatenMeals = await getDailyEatenMealsHelper(userId ,date)

        let dailyCalories =0;
        let dailyProtein =0 ;
        let dailyFat =0;
        let dailyCarbs =0;

        const userDailyEatenMealsData = userDailyEatenMeals.data;

        const userMealNutrition = userDailyEatenMealsData.map(meal=>meal.nutrition)

        for (const mealNutrition of userMealNutrition){
            dailyCalories+=mealNutrition?.calories_kcal || 0;
            dailyProtein+=mealNutrition?.protein_g || 0;
            dailyCarbs += mealNutrition?.carbs_g || 0;
            dailyFat+=mealNutrition?.fat_g || 0
        }

        return{
            date: format(date,'yyyy-MM-dd'),
            total_calories_kcal:dailyCalories,
            total_protein_g:dailyProtein,
            total_fat_g:dailyFat,
            total_carbs_g:dailyCarbs
        }
    }
    catch(err){
        throw new Error(`Failed to generate daily summary: ${err.message}` , {cause:err})
    }
}