import admin from '../../utils/firebase-admin.cjs'
import { userExpiryReminder } from './UserExpiryReminder.js';


export async function allUsersExpiryReminder(){
    const database = admin.firestore();
    const allMessages =[]
    try{
        const userSnapshot = await database.collection('users').get()
        const usersData = userSnapshot.docs.map(doc=>({
            userId:doc.id,
            ...doc.data()
        }))
        usersData.forEach(async userData=>{
            const userId = userData.userId;
            const userFcmToken = userData?.fcm_token || "";
            const userNotifications = await userExpiryReminder(userId,userFcmToken)
            allMessages.push(...userNotifications);
        })

        if(allMessages.length > 0){
            const response = await  admin.messaging().sendEach(allMessages)
            if(response.failureCount > 0){
                response.responses.forEach((failureResponse , index)=>{
                    if(!failureResponse.success){
                        console.error(`Failed to send notification to token ${allMessages[index].token}` , failureResponse.error)
                    }
                })
            }
        }
    }
    catch(err){
        throw new Error("Failed to batch send expiry reminder" ,{cause:err})
    }
}