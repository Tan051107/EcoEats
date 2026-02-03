import admin from '../utils/firebase-admin.cjs'

const database = admin.firestore()

export async function packageTypeMapping(materialList){
    try{
        const packageTypeSnapshot = await database.collection('grocery_keys').doc('packaged').get()
        const packagedData = packageTypeSnapshot.data();
        const packageTypeData = packagedData.packaging_types
        const lookUp = {}

        for (const[_,typeData] of Object.entries(packageTypeData)){
            for (const key of typeData.similarKeys){
                lookUp[key.toLowerCase()] ={
                    packaging_materials:key,
                    recommendedDisposalWay:typeData.recommendedDisposalWay
                }
            }
        }

        const materialsFound = materialList.map(material=>{
            material = material.toLowerCase();
            if(lookUp[material]){
                return {
                    ...lookUp[material]
                }
            }
            return{
                packaging_materials:material,
                recommendedDisposalWay: "Empty, rinse, and dry it before recycling; if it’s greasy, throw it away"
            }
        })

        return {
            success:true,
            message:"Retrieved mappings for item packaging",
            data:materialsFound
        }
    }
    catch(err){
        throw new Error("Failed to map packaging type with packaging type in database" , {cause:err})
    }
}