const admin = require('firebase-admin')


const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp(
    {
        credential:admin.credential.cert(serviceAccount),
        storageBucket:"ecoeats-4f19c.firebasestorage.app"
    }
)

module.exports = admin

