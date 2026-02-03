import * as functions from 'firebase-functions'
import admin from '../utils/firebase-admin.cjs'

export const getNotifications = functions.https.onCall(async(_,context)=>{

    if(!context.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed")
    }

    const userId = context.auth.uid;

    const database = admin.firestore()

    try{
        const userRef = database.collection('users').doc(userId)
        const notificationsSnapshot = await userRef.collection('notifications')
                                             .where('show' , '!=' , false)
                                             .get()

        const notificationsData = notificationsSnapshot.docs.map(doc=>({
            notificationId:doc.id,
            ...doc.data()
        }))

        return{
            success:true,
            message:"Successfully retrieved all user notifications",
            data:notificationsData
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }
})