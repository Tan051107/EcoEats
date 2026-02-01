import * as functions from 'firebase-functions'
import { getAllRecipes } from './GetAllRecipesHelper'

export const getRecipes = functions.https.onCall(async()=>{
    try{
        const allRecipes = await getAllRecipes()
        
        return allRecipes
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }
})