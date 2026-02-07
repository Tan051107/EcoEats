import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import {format} from 'date-fns'

export async function addUserWeeklySummary(userId ,weeklySummary,startOfLastWeek){
    const database = admin.firestore();
    const weeklySummaryDocId = format(startOfLastWeek , "yyyy-MM-dd")
    const userRef = database.collection('users').doc(userId);
    const weeklySummaryDocRef = userRef.collection('weeklySummary').doc(weeklySummaryDocId)

    try{
        await weeklySummaryDocRef.set({
            ...weeklySummary,
            created_at:admin.firestore.FieldValue.serverTimestamp()
        })
    }
    catch(err){
        throw new Error("Failed to add new weekly summary:",err.message)
    }

}