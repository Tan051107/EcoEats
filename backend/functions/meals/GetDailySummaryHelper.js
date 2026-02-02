import { getDailyEatenMealsHelper } from "./GetDailyEatenMealsHelper"
import { format } from "date-fns";

export async function getDailySummaryHelper(userId, date){
    const userDailyEatenMeals = await getDailyEatenMealsHelper(userId ,date)

    if(!userDailyEatenMeals.success){
        return userDailyEatenMeals
    }

    let dailyCalories =0;
    let dailyProtein =0 ;
    let dailyFat =0;
    let dailyCarbs =0;

    const userDailyEatenMealsData = userDailyEatenMeals.data;

    const userMealNutrition = userDailyEatenMealsData.map(meal=>meal.nutrition)

    for (const mealNutrition of userMealNutrition){
        dailyCalories+=mealNutrition.calories;
        dailyProtein+=mealNutrition.protein;
        dailyCarbs += mealNutrition.carbs;
        dailyFat+=mealNutrition.fat
    }

    return{
        date: format(date,'yyyy-MM-dd'),
        total_calories_kcal:dailyCalories,
        total_protein_g:dailyProtein,
        total_fat_g:dailyFat,
        total_carbs_g:dailyCarbs
    }
}