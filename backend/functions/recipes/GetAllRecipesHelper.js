import admin from '../utils/firebase-admin.cjs'

export async function getAllRecipes(category,chef){
    try{
        const database = admin.firestore()

        let query = database.collection('recipes');

        if(category !== undefined){
            query = query.where('diet_type', "==" ,category)
        }

        if(chef !== undefined){
            query = query.where("chef_name" , "==" , chef)
        }

        const recipesSnapshot = await query.orderBy('nutrition.calories_kcal' , 'asc').get();

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
        throw new Error("Failed to retrieve all recipes"+ err.message , {cause:err})
    }
}