import admin from '../utils/firebase-admin.cjs'

export async function getPackagedNutritionFromDatabase(barcode){
    const database = admin.firestore();
    try{
        const barcodeDocSnapshot = await database.collection("packagedFoodInfo").doc(barcode).get()
        const barcodeDocData = barcodeDocSnapshot.data()
        if(barcodeDocSnapshot.exists){
            return{
                success:true,
                message:"Successfully return grocery info from database",
                data:{
                    ...barcodeDocData.info,
                    is_packaged:true,
                }
            }
        }
        else{
            return{
                success:false,
                message:"Barcode not found in database",
                data:{}
            }
        }
    }
    catch(err){
        throw new Error("Failed to retrive grocery info of the barcode from database:" ,err.message)
    }
}