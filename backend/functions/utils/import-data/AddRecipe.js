import admin from '../firebase-admin.cjs'

export async function addRecipes(recipes){

    const database = admin.firestore()
    const batch = database.batch()
    let recipesAdded = []

    try{
        for (const recipe of recipes){
            const docRef = database.collection('recipes').doc();
            batch.set(docRef , recipe)
            recipesAdded.push({
                recipeId:docRef,
                ...recipe
            })
        }
        await batch.commit()
        return{
            success:true,
            message:"Added new recipes to database",
            data:recipesAdded
        }
    }
    catch(err){
        throw new Error("Failed to add new recipes to database" , {cause:err})
    }
}
