const admin = require('firebase-admin')

// Authentication is supplied by Firebase/Google Cloud when deployed, or by
// GOOGLE_APPLICATION_CREDENTIALS when running locally. Never commit that file.
const storageBucket = process.env.ECOEATS_STORAGE_BUCKET || process.env.FIREBASE_STORAGE_BUCKET;

if (!admin.apps.length) {
    admin.initializeApp(storageBucket ? { storageBucket } : undefined)
}

module.exports = admin

