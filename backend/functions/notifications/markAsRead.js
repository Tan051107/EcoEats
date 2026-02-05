import * as functions from 'firebase-functions'
import admin, { firestore } from '../utils/firebase-admin.cjs'
import Joi from 'joi'

export const markAsRead = functions.https.onCall(async(data,context)=>{
    if(!context.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed.")
    }

    const userId = context.auth.uid;

    const schema = Joi.object({
        notification_id:Joi.string().required()
    })

    const {errors , value} = schema.validate(data)

    if(errors){
        throw new functions.https.HttpsError('invalid-argument' , errors.details.map(detail=>({field:detail.path.join(".") , message:detail.message})))
    }

    const database = admin.firestore()

    const {notificationId} = value

    try{
        const userRef = database.collection('users').doc(userId)
        const userNotificationRef = userRef.collection('notifications').doc(notificationId)
        const userNotificationSnapshot = await userNotificationRef.get()

        if(!userNotificationSnapshot.exists){
            throw new functions.https.HttpsError('not-found' , "Notification not found.")
        }

        await userNotificationRef.update({
            read: true,
            read_at:admin.firestore.FieldValue.serverTimestamp()
        })

        return{
            success:true,
            message:"Successfully mark notification as read."
        }
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }
})