import * as functions from 'firebase-functions'
import admin from '../utils/firebase-admin.cjs'

export const markAllAsRead = functions.https.onCall(async(_,context)=>{
    if(!context.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed")
    }

    const userId = context.auth.uid;

    const database = admin.firestore()

    try{
        const userRef = database.collection('users').doc(userId)

        const notificationsSnapshot = await userRef.collection('notifications')
                                                    .where('read' , '=='  ,false)
                                                    .get()
        
        const batch = database.batch()

        notificationsSnapshot.docs.forEach(doc=>{
            batch.update(doc.ref , {
                read:true,
                read_at:admin.firestore.FieldValue.serverTimestamp()       
            }
            )
        })

        await batch.commit()

        return{
            success:true,
            message:"Successfully mark all as read"
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }
})