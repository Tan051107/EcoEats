const admin = require('../firebase-admin.cjs')


const packagingData = require('../json/packagingTypes.json')



const database = admin.firestore()

async function addPackagingTypes(){
    try{
        const docRef = database.collection('grocery_keys').doc('packaged')
        await docRef.set({
            packaging_types:packagingData
        }, {merge:true})
        console.log("Packaging Type imported successfully")
    }
    catch(err){
        console.error("Failed to import packaging types", err)
    }
}

addPackagingTypes()



