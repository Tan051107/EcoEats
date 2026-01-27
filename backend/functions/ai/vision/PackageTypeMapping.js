import admin from '../../utils/firebase-admin.cjs'

const database = admin.firestore()

export async function packageTypeMapping(materialList){
    try{
        const packageTypeSnapshot = await database.collection('grocery_keys').doc('packaged').get()
        const packageTypeData = packageTypeSnapshot.data();
        const materialsFound  =[]

        for (const material of materialList){
            material = material.toLowerCase();
            for (const [typeName ,typeData] of Object.entries(packageTypeData)){
                if(typeData.similarKeys.some(key=>key.toLowerCase() === material)){
                    materialsFound.push({
                        found:true,
                        packaging:typeName,
                        recommendedDisposalWay:typeData.recommendedDisposalWay
                    })
                }
            }
            materialsFound.push({
                found:false,
                packaging:material
            })
        }
    }
    catch(err){
        console.error("Failed to map packaging type with packaging type in database" ,err.message)
    }
}