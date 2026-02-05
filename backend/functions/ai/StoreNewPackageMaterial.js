import admin from '../utils/firebase-admin.cjs'

export async function storeNewPackageMaterials(result){
    const database = admin.firestore()

    const packagedSnapShot = database.collection("grocery_keys").doc("packaged");

    const packagedKey = await packagedSnapShot.get();

    const packagedKeyData = packagedKey.data()



    for (const [_,data] of Object.entries(packagedKeyData.packaging_types)){
            result = result.filter(material => !data.similarKeys.some(key=>key.toLowerCase() === material?.name.toLowerCase()))
        }

    if(!Array.isArray(result) || result.length === 0){
        return;
    }

    const updates ={};

    for (const material of result){
        if(material?.name && material?.recommendedDisposalWay){
            updates[`packaging_types.${material.name}.recommendedDisposalWay`] = material.recommendedDisposalWay;
            updates[`packaging_types.${material.name}.similarKeys`] = [material.name];
        }
    }

    try{
        await packagedSnapShot.set(updates , {merge:true})
        return{
            success:true,
            message:"Added new materials to packaging_type field in packaged doc"
        }
    }
    catch(err){
        throw new Error("Error when adding new materials to packaging_type field in packaged doc" , {cause:err})
    }

}