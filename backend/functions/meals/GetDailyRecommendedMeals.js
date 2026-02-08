import * as functions from 'firebase-functions'
import admin from '../utils/firebase-admin.cjs'
import { format } from 'date-fns'

export const getDailyRecommendedMeals = functions.https.onCall(async(request)=>{

    if(!request.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed.")
    }

    const userId = request.auth.uid;

    const today = new Date();

    const dailyRecommendedMealsDocId = format(today, "yyyy-MM-dd")

    const database = admin.firestore()

    const userRef = database.collection('users').doc(userId);

    try{
        const dailyRecommendedMealsDocSnapshot = await userRef.collection('recommendedMeals').doc(dailyRecommendedMealsDocId).get()

        if(!dailyRecommendedMealsDocSnapshot.exists){
            throw new functions.https.HttpsError('not-found' , "Daily recommended meal data not found.")
        }

        const dailyRecommendedMealsData = dailyRecommendedMealsDocSnapshot.data();

        const {meals , created_at , ...mealData} = dailyRecommendedMealsData;
        const mealsId = [meals.breakfast.recipe_id , meals.lunch.recipe_id ,meals.dinner.recipe_id ]

        const [breakfastSnapshot,lunchSnapshot,dinnerSnapshot] = await Promise.all(
            mealsId.map(mealId=>
                database.collection('recipes').doc(mealId).get()
            )
        )

        if (!breakfastSnapshot.exists || !lunchSnapshot.exists || !dinnerSnapshot.exists) {
            throw new functions.https.HttpsError(
                'not-found',
                'One or more recipes not found.'
            )
        }

        const breakfast = {
            mealId:breakfastSnapshot.id,
            ...breakfastSnapshot.data()
        }

        const lunch = {
            mealId:lunchSnapshot.id,
            ...lunchSnapshot.data()
        }

        const dinner = {
            mealId:dinnerSnapshot.id,
            ...dinnerSnapshot.data()
        }

        return{
            success:true,
            message:"Successfully returned all daily meal recommendations.",
            data:{
                breakfast:breakfast,
                lunch:lunch,
                dinner:dinner,
                ...mealData
            }
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }

})