import {differenceInCalendarDays} from 'date-fns'
import admin from '../../utils/firebase-admin.cjs'

export async function userExpiryReminder(userId , userFcmToken){
    const expiryReminderDay = [7,3,1];
    const today = new Date();
    
    const database = admin.firestore()
    const batch = database.batch()
    const userRef = database.collection('users').doc(userId)

    const allMessages = []

    try{
        const grocerySnapshot = await userRef.collection('shelf').get()
        const userGroceries = grocerySnapshot.docs.map(doc=>({
            groceryId:doc.id,
            ...doc.data()
        }))

        if(userGroceries.length < 1){
            return;
        }

        for (const grocery of userGroceries){
            if(!"expiry_date" in grocery){
                continue;
            }
        
            const expiryDate = new Date(grocery.expiry_date)
            const difference = differenceInCalendarDays(expiryDate,today)

            if(expiryReminderDay.includes(difference) && grocery.quantity >0){
                const notificationRef = userRef.collection('notifications').doc()
                const title = "Grocery will expire soon";
                const message = `Your ${grocery.item_name} will expire in ${difference} day${difference>1? "s": ""}. Consume it as soon as possible.`

                const inAppNotification = {
                    type:"expiry_warning",
                    title:title,
                    message:message,
                    related_item_id:grocery.groceryId,
                    read:false,
                    show:true,
                    created_at:admin.firestore.FieldValue.serverTimestamp()
                }

                batch.set(notificationRef ,inAppNotification)

                if(!userFcmToken){
                    continue;
                }

                allMessages.push({
                    token:userFcmToken,
                    notification:{
                        title:title,
                        body:message
                    }
                })
            }
        }
        await batch.commit()
        return allMessages;
    }
    catch(err){
        throw new Error(`Failed to generate expiry reminder for user ${userId}` , {cause:err})
    }
}