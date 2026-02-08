import admin from '../../utils/firebase-admin.cjs'
import {generateMealPlans} from './GenerateMealPlan.js'
import { generateMealPlansWithAI } from '../../ai/GenerateMealPlansWithAI.js';
import { getUserDailyCalorieIntake } from '../../utils/GetUserDailyCalorieIntake.js';

export async function getUserDailyMealPlan(userData ,recipeData){
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


        const userGroceries = userGroceriesSnapshot.docs.map(doc=>doc.data().item_name.toLowerCase())
                                                    .filter(Boolean) //avoid undefined
        
        
        const userTakenRecipes = userMealsSnapshot.docs.map(doc=>({
            docId:doc.id,
            ...doc.data()
        }))
        const userTakenRecipeIds = userTakenRecipes.filter(recipe => 'recipe' in recipe)
                                                    .map(recipe=>recipe.docId)
        
        const userTakenRecipeNames = userTakenRecipes.map(recipe=>recipe.name)
        
        const {allergies ,diet_type:userDietType ,activity_level,goal,bmr} = userData;
        
        let availableRecipes = recipeData.filter(recipe=>!userTakenRecipeIds.includes(recipe.recipeId))
                                         .filter(recipe=>!recipe.allergens.some(allergen=>allergies.includes(allergen)))
        
        switch(userDietType){
            case "vegetarian":
                availableRecipes = availableRecipes.filter(
                    recipe => recipe.diet_type && recipe.diet_type.toLowerCase().trim() !== 'non-vegetarian'
                );
                break;
            case "vegan":
                availableRecipes = availableRecipes.filter(recipe=>recipe.diet_type === 'Vegan');
                break;
            default:
                break;   
        }

        let mealPlans;

        const dailyCalorieIntake = getUserDailyCalorieIntake(activity_level,goal,bmr)

        if(availableRecipes.length === 0){
            console.log("No available recipes.Calling vertex ai to generate meal plan")
            //mealPlans = await generateMealPlansWithAI(userGroceries , dailyCalorieIntake , userDietType , userTakenRecipeNames , allergies)
        }

        console.log("EXECUTING TO CALL GENERATE MEAL PLAN")

        mealPlans = generateMealPlans(availableRecipes,dailyCalorieIntake,userGroceries);
        console.log("EXECUTED TO CALL GENERATE MEAL PLAN")

        if(!mealPlans.success){
            console.log("Failed to generate suitable recipes from database.Calling vertex ai to generate meal plan")
            //mealPlans = await generateMealPlansWithAI(userGroceries , dailyCalorieIntake , userDietType , userTakenRecipeNames , allergies )
        }

        return mealPlans;
    }
    catch(err){
        console.log("Failed to generate meal recommendation" , err.message)
        throw new Error("Failed to generate meal recommendation" , err.message)
    }

}