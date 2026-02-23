import admin from '../utils/firebase-admin.cjs'

export async function overwritePackagedInfo(pendingEdits,packagedFoodDataDocId){
    const database = admin.firestore();
    const packagedFoodDocRef = database.collection("packagedFoodInfo").doc(packagedFoodDataDocId)
    try{
        for (let i =0 ; i<pendingEdits.length ; i++){
            const pendingEdit = pendingEdits[i]
            if(pendingEdit.verified_count > 5){
                if(pendingEdit.hasOwnProperty("nutrition")){
                    for(const [nutritionKey,nutritionValue] of Object.entries(pendingEdit.nutrition)){
                        console.log(`Verified count  > 5 , overwrite ${nutritionKey} current info`)
                        await packagedFoodDocRef.set(
                            {
                                info:{
                                    nutrition:{
                                        [nutritionKey]:nutritionValue
                                    }
                                }
                            }, {merge:true})
                    }
                }
                if(pendingEdit.hasOwnProperty("name")){
                    console.log(`Verified count  > 5 , overwrite item_name current info`)
                    await packagedFoodDocRef.set(
                        {
                            info:{category:pendingEdit.item_name}
                        },
                        {merge:true}
                    )
                }
                if(pendingEdit.hasOwnProperty("category")){
                    console.log(`Verified count  > 5 , overwrite category current info`)
                    await packagedFoodDocRef.set(
                        {
                            info:{category:pendingEdit.category},
                        },
                        {merge:true}
                    )
                }   
                pendingEdits.splice(i,1)   
            }
        }
        await packagedFoodDocRef.set(
            {
                pending_edits:pendingEdits,
                updated_at:admin.firestore.FieldValue.serverTimestamp()
            },
            {merge:true}
        )
    }
    catch(err){
        throw new Error("Failed to overwrite exisiting packaged info", err.message )
    }
}