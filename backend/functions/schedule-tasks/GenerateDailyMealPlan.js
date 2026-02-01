import admin from '../utils/firebase-admin.cjs'
import { getMostSuitableMealPlans } from './GetMostSuitableMealPlans';

export async function generateDailyMealPlan(userData ,recipeData){
    const database = admin.firestore()
    const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    const userDocRef = database.collection('users').doc(userData.userId);
    const userMealsRef = userDocRef.collection('meals')
    const userGroceriesRef = userDocRef.collection('shelf')

    try{
        const [userMealsSnapshot , userGroceriesSnapshot] = await Promise.all(
            [
                userMealsRef.where("created_at" , ">=" , sevenDaysAgo).get(), //get meals from last seven days)
                userGroceriesRef.get()
            ]);
        const userTakenRecipes = userMealsSnapshot.docs.filter(doc=> 'recipe' in doc.data())
                                                    .map(doc=>doc.id)
        
        const userGroceries = userGroceriesSnapshot.docs.map(doc=>doc.data().item_name.toLowerCase())
                                                         .filter(Boolean) //avoid undefined
        
        const availableRecipes = recipeData.filter(recipe=>!userTakenRecipes.some(userTakenRecipe=> userTakenRecipe === recipe.recipeId))
                                            .filter(recipe=>recipe.allergens.some(allergen=>userData.allergies.includes(allergen)))
        
        if(userData.diet_type === 'vegetarian' || userData.diet_type === 'vegan'){
            if(userData.diet_type === "vegetarian"){
                availableRecipes.filter(recipe=>recipe.diet_type !== 'Non-vegetarian')
            }
            else{
                availableRecipes.filter(recipe=>recipe.diet_type === 'Vegan')
            }
        }

        if(availableRecipes.length === 0){
            console.log("Call vertex ai to generate recipe")
        }

        let activityLevel = 1.2;
        let calorieIntakePercentage = 1

        switch(userData.activity_level){
            case "sedentary":
                activityLevel = 1.2;
                break;
            case "light":
                activityLevel = 1.375;
                break;
            case"moderate":
                activityLevel = 1.55;
                break;
            case "active":
                activityLevel = 1.725;
                break;
            case "very_active":
                activityLevel = 1.9;
                break;
            default:
                activityLevel = 1.2;
                break;
        }

        switch(userData.goal){
            case "lose_weight":
                calorieIntakePercentage = 0.85
                break;
            case "gain_weight":
                calorieIntakePercentage = 1.15
                break;
            case "maintain_weight":
                calorieIntakePercentage = 1
                break;
            case "eat_healthier":
                calorieIntakePercentage = 1
                break;
            default:
                calorieIntakePercentage = 1
                break;
        }

        const dailyCalorieIntake = userData.bmr*activityLevel*calorieIntakePercentage;

        const mealPlans = getMostSuitableMealPlans(availableRecipes,dailyCalorieIntake,userGroceries);

        if(!mealPlans.success){
            console.log("Call vertex ai to generate recipe")
        }
    }
    catch(err){
        return{
            success:false,
            message:err.message,
            data:{}
        }
    }

}