import * as functions from 'firebase-functions'
import admin from '../utils/firebase-admin.cjs'

export const clearNotification = functions.https.onCall(async(request)=>{
    if(!request.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proeceed")
    }

    const userId = request.auth.uid;

    const database = admin.firestore()

    try{
        const userRef = database.collection('users').doc(userId);
        const notificationsSnapshot = await userRef.collection('notifications')
                                        .where('show' , '==' , true)
                                        .where('read' , '==' , true)
                                        .get()

        const batch = database.batch();

        notificationsSnapshot.docs.forEach(doc=>{
            batch.update(doc.ref , {show:false})
        })

        await batch.commit()

        return{
            success:true,
            message:"Cleared notifications that are read",
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal', err.message)
    }
})