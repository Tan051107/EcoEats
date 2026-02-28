const admin = require('firebase-admin')


if (!admin.apps.length) {
    admin.initializeApp(
        {
            storageBucket: "ecoeats-4f19c.firebasestorage.app"
        }
    )
}

module.exports = admin

