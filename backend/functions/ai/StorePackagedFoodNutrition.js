import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import { getPackagedInfoPendingEdits } from './GetPackagedInfoPendingEdits.js';
import { overwritePackagedInfo } from './OverwritePackagedInfo.js';

export async function storePackagedFoodNutrition(barcode , packagedFoodData){
    const database = admin.firestore();
    const packagedFoodDataDocId = barcode
    const packagedFoodDocRef = database.collection("packagedFoodInfo").doc(packagedFoodDataDocId)
    try{
        const packagedFoodDoc = await packagedFoodDocRef.get()
        if(packagedFoodDoc.exists){
            const packagedFoodInfo = packagedFoodDoc.data();
            const {info,pending_edits} = packagedFoodInfo;
            const edits = pending_edits || []
            console.log("info")
            console.log(JSON.stringify(info, null, 2));
            console.log("Barcode found. Will overwrite packaged info")
            const pendingEdits = getPackagedInfoPendingEdits(packagedFoodData,info,edits)
            await overwritePackagedInfo(pendingEdits,packagedFoodDataDocId)
            console.log(" Overwritten overwrite packaged info")
        }
        else{
            console.log("Barcode not found. Will add to packaged food collection")
            packagedFoodDocRef.set({
                info:{
                    ...packagedFoodData,
                },
                pending_edits:[],
                created_at:admin.firestore.FieldValue.serverTimestamp(),
                updated_at:admin.firestore.FieldValue.serverTimestamp()
            })
            console.log("Done added Barcode not found packaged food to collection")
        }
    }
    catch(err){
        console.log(err.message)
        throw new Error(`Failed to store new packaged info: ${err.message}`)
    }
}


