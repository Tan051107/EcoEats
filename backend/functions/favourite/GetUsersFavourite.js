import * as functions from 'firebase-functions'
import { getUsersFavouriteHelper } from './GetUsersFavouriteHelper.js';
import { getAllRecipes } from '../recipes/GetAllRecipesHelper.js';

export const getUsersFavourite=functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed");
    }

    const userId = request.auth.uid;


    try{
        const userFavourites = await getUsersFavouriteHelper(userId);
        const allRecipes = await getAllRecipes();
        const allRecipesData = allRecipes.data;

        if(allRecipesData.length ==0){
            return{
                success:false,
                message:"No recipes available",
                data:[]
            }
        }

        if(userFavourites.length == 0){
            return {
                success:true,
                message:"User has no favourite",
                data:[]
            }  
        }

        const userFavouriteRecipes = allRecipesData.filter(recipe=>userFavourites.includes(recipe.recipeId));

        return {
            success:true,
            message:"Returned all users favourite",
            data:userFavouriteRecipes
        }

    }
    catch(err){
        throw new functions.https.HttpsError("internal" , `Failed to get user favourites:${err.message}`)
    }
})