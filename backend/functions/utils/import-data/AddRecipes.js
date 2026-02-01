import admin from '../firebase-admin.cjs'
//const recipes = require('./json/recipes.json')

export async function addRecipes(recipes){

    const database = admin.firestore()
    const batch = database.batch()

    try{
        for (const recipe of recipes){
            const docRef = database.collection('recipes').doc();
            batch.set(docRef , recipe)
        }
        await batch.commit()
        console.log("Done uploading all recipes to Firestore")
    }
    catch(err){
        console.log("Failed to uploading recipes to Firestore" + err.message)
    }
}


