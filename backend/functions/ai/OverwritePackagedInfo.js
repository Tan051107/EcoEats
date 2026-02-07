import admin from '../utils/firebase-admin.cjs'

export async function overwritePackagedInfo(pendingEdits){
    const database = admin.firestore();
    const packagedFoodDataDocId = barcode || packagedFoodData?.item_name || ""
    const packagedFoodDocRef = database.collection("packagedFoodInfo").doc(packagedFoodDataDocId)
    try{
        for (let i =0 ; i<pendingEdits.length ; i++){
            const pendingEdit = pendingEdits[i]
            if(pendingEdit.verified_count > 5){
                if(pendingEdit.hasOwnProperty("nutrition")){
                    for(const [nutritionKey,nutritionValue] of Object.entries(pendingEdit.nutrition)){
                        await packagedFoodDocRef.set(
                            {nutrition:{
                                [nutritionKey]:nutritionValue
                            }
                        }, {merge:true})
                    }
                }
                if(pendingEdit.hasOwnProperty("item_name")){
                    await packagedFoodDocRef.set(
                        {item_name:pendingEdit.item_name},
                        {merge:true}
                    )
                }
                if(pendingEdit.hasOwnProperty("category")){
                    await packagedFoodDocRef.set(
                        {category:pendingEdit.category},
                        {merge:true}
                    )
                }   
                pendingEdits.splice(i,1)   
            }
        }
        await packagedFoodDocRef.set(
            {pending_edit:pendingEdits},
            {merge:true}
        )
    }
    catch(err){
        throw new Error("Failed to overwrite exisiting packaged info", err.message )
    }
}