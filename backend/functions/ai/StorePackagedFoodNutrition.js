import admin from '../utils/firebase-admin.cjs'
import { getPackagedInfoPendingEdits } from './GetPackagedInfoPendingEdits.js';
import { overwritePackagedInfo } from './OverwritePackagedInfo.js';

export async function storePackagedFoodNutrition(barcode , packagedFoodData){
    const database = admin.firestore();
    const packagedFoodDataDocId = barcode || packagedFoodData?.item_name || ""
    const packagedFoodDocRef = database.collection("packagedFoodInfo").doc(packagedFoodDataDocId)
    try{
        const packagedFoodDoc = await packagedFoodDocRef.get()
        if(packagedFoodDoc.exists){
            const packagedFoodInfo = packagedFoodDoc.data();
            const {info,pending_edits} = packagedFoodInfo;
            const pendingEdits = getPackagedInfoPendingEdits(packagedFoodData,info,pending_edits)
            await overwritePackagedInfo(pendingEdits)
        }
        else{
            packagedFoodDocRef.set({
                ...packagedFoodData,
                pending_edits:[]
            })
        }
    }
    catch(err){
        throw new Error("Failed to store new packaged info:",err.message)
    }
}