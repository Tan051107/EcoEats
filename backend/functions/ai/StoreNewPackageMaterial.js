import admin from '../utils/firebase-admin.cjs'

export async function storeNewPackageMaterials(result){
    const database = admin.firestore()

    const packagedSnapShot = database.collection("grocery_keys").doc("packaged");

    const packagedKey = await packagedSnapShot.get();

    const packagedKeyData = packagedKey.data()



    for (const [_,data] of Object.entries(packagedKeyData.packaging_types)){
            result = result.filter(material => !data.similarKeys.some(key=>key.toLowerCase() === material?.material.toLowerCase()))
        }

    if(!Array.isArray(result) || result.length === 0){
        return;
    }

    const updates ={};

    for (const material of result){
        if(material?.material && material?.recommendedDisposalWay){
            updates[`packaging_types.${material.material}.recommendedDisposalWay`] = material.recommendedDisposalWay;
            updates[`packaging_types.${material.material}.similarKeys`] = material.material;
        }
    }

    try{
        await packagedSnapShot.set(updates , {merge:true})
        console.log("Added new materials to packaging_type field in packaged doc")
    }
    catch(err){
        console.log("Error when adding new materials to packaging_type field in packaged doc" + err.message)
    }

}