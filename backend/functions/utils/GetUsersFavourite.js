import admin from './firebase-admin.cjs';

export async function getUsersFavourite(userId){
    const database = admin.firestore();
    const userRef = database.collection("users").doc(userId);
    const userFavouriteRecipesSnapshot = await userRef.collection("favourites").get();

    if(userFavouriteRecipesSnapshot.empty){
        return [];
    }

    const userFavouriteRecipesData = userFavouriteRecipesSnapshot.docs.map(doc=>({
        docId:doc.id,
        ...doc.data()
    }))

    const userFavouriteRecipesId = userFavouriteRecipesData.map(recipe=>recipe.recipe_id);

    return userFavouriteRecipesId
}