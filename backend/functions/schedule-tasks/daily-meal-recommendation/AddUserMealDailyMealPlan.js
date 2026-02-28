import {format , addDays} from "date-fns"
import admin from '../../utils/firebase-admin.cjs'
import { formatInTimeZone } from "date-fns-tz";

export function addUserDailyMealPlan(batch , userId , mealPlanData){
    const today  = formatInTimeZone(new Date(),"Asia/Kuala_Lumpur",'yyyy-MM-dd')
    const tmr = addDays(today,1);
    const tmrDate = format(tmr , "yyyy-MM-dd")
    const database = admin.firestore();

    let totalCarbs = 0;
    let totalProtein = 0;
    let totalFat =0;

    const meals =[mealPlanData.breakfast , mealPlanData.lunch , mealPlanData.dinner];

    for (const meal of meals){
        totalCarbs+=meal.nutrition.carbs_g;
        totalProtein+=meal.nutrition.protein_g;
        totalFat+=meal.nutrition.fat_g
    }

    const fields = {
        date:tmrDate,
        meals:{
            breakfast:mealPlanData.breakfast.recipeId,
            lunch:mealPlanData.lunch.recipeId,
            dinner:mealPlanData.dinner.recipeId,     
        },
        total_calories_kcal:mealPlanData.totalCalories,
        total_protein_g:totalProtein,
        total_fat_g:totalFat,
        total_carbs_g:totalCarbs,
        missing_ingredients:mealPlanData.missingIngredients,
        created_at:admin.firestore.FieldValue.serverTimestamp()
    }

    try{
        const userRef  = database.collection('users').doc(userId)
        const mealPlanRef = userRef.collection('recommendedMeals').doc(tmrDate)

        batch.set(mealPlanRef,fields)
    }
    catch(err){
        throw new Error("Failed to add user daily meal plans" , err.message)
    }
    
}