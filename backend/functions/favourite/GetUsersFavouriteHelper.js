import admin from '../utils/firebase-admin.cjs';

export async function getUsersFavouriteHelper(userId){
    const database = admin.firestore();
    const userRef = database.collection("users").doc(userId);

    const userFavouriteRecipesSnapshot = await userRef.collection("favourites").get();

    if(userFavouriteRecipesSnapshot.empty){
        return [];
    }

    const userFavouriteRecipesId = userFavouriteRecipesSnapshot.docs.map(doc=>doc.id)

    return userFavouriteRecipesId
}