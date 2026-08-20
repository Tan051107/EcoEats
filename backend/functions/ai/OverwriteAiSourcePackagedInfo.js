import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 

export async function overwriteAiSourcePackagedInfo(packagedFoodDataDocId,newData){
    const database = admin.firestore();

    const packagedFoodRef = database.collection("packagedFoodInfo").doc(packagedFoodDataDocId)

    const packagedFoodSnapshot = await packagedFoodRef.get()

    const packagedFoodData = packagedFoodSnapshot.data();

    const {info} = packagedFoodData;

    const {
        item_name:currentItemName,
        category:currentCategory,
        nutrition:currentNutrition
    } = info;

    const {
        item_name:newName,
        category:newCategory,
        nutrition:newNutrition
    } = newData

    const pendingEdits = [
        {
            item_name:currentItemName,
            verified_count:1
        
        },
        {
            category:currentCategory,
            verified_count:1
        },
        ...Object.entries(currentNutrition).map(([nutritionKey,nutritionValue])=>({
            nutrition:{
                [nutritionKey]:nutritionValue
            },
            verified_count:1
        }))
    ]

    const newInfo = {
        item_name:newName,
        category:newCategory,
        nutrition:newNutrition
    }

    try{
        await packagedFoodRef.set({
            info:newInfo,
            pending_edits:pendingEdits,
            source:"user_verified",
            updated_at:admin.firestore.FieldValue.serverTimestamp()
        },{merge:true})
    }
    catch(err){
        throw new Error(`Failed to overwrite AI source packaged food info in database:${err.message}`)
    }
}