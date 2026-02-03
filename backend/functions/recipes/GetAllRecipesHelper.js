import admin from '../utils/firebase-admin.cjs'

export async function getAllRecipes(){
    try{
        const database = admin.firestore()

        const recipesSnapshot = await database.collection('recipes').orderBy('nutrition.calories_kcal' , 'asc').get();

        const recipesData = recipesSnapshot.docs.map(doc=>({
            recipeId:doc.id,
            ...doc.data()
        }))

        return{
            success:true,
            message:"Successfully retrieved all recipes",
            data:recipesData
        }
    }
    catch(err){
        throw new Error("Failed to retrieve all recipes" , {cause:err})
    }
}