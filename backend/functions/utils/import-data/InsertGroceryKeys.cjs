const admin = require('../../utils/firebase-admin')


const serviceAccount = require('./json/serviceAccountKey.json');

admin.initializeApp({
    credential:admin.credential.cert(serviceAccount)
});

const database = admin.firestore();

const freshKeys = require('../../ai/vision/json/fresh.json');
const packagedKeys = require('../../ai/vision/json/packaged.json');

async function insertGroceryKeys() {
    try{
        await database.collection('grocery_keys').doc('fresh').set(freshKeys);
        await database.collection('grocery_keys').doc('packaged').set(packagedKeys);
        console.log('Grocery keys inserted successfully.');
        process.exit(0);
    }
    catch(err){
        console.error('Error inserting grocery keys:', err);
        process.exit(1);
    }
}

insertGroceryKeys();