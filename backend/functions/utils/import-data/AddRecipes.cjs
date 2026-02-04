const admin = require('../firebase-admin.cjs')
const recipes = require('./json/recipes-with-chef.json')

async function addRecipes(){

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
        console.log(err.message)
    }
}

addRecipes()


