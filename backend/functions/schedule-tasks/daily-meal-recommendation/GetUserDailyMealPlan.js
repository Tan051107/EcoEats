import admin from '../../utils/firebase-admin.cjs'
import { generateMealPlan } from './GenerateMealPlan.js';
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
        
        const availableRecipes = recipeData.filter(recipe=>!userTakenRecipeIds.includes(recipe.recipeId))
                                            .filter(recipe=>recipe.allergens.some(allergen=>allergies.includes(allergen)))
        
        switch(userDietType){
            case "vegetarian":
                availableRecipes.filter(recipe=>recipe.diet_type !== 'Non-vegetarian');
                break;
            case "vegan":
                availableRecipes.filter(recipe=>recipe.diet_type === 'Vegan');
                break;
            default:
                break;   
        }

        let mealPlans;

        const dailyCalorieIntake = getUserDailyCalorieIntake(activity_level,goal,bmr)

        if(availableRecipes.length === 0){
            mealPlans = await generateMealPlansWithAI(userGroceries , dailyCalorieIntake , userDietType , userTakenRecipeNames , allergies)
        }

        mealPlans = generateMealPlan(availableRecipes,dailyCalorieIntake,userGroceries);

        if(!mealPlans.success){
            mealPlans = await generateMealPlansWithAI(userGroceries , dailyCalorieIntake , userDietType , userTakenRecipeNames , allergies )
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