const admin = require('firebase-admin')



const serviceAccount = require('../ai/vision/json/serviceAccountKey.json');

admin.initializeApp(
    {
        credential:admin.credential.cert(serviceAccount)
    }
)

module.exports = admin

