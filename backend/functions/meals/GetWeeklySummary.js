import admin from '../utils/firebase-admin.cjs'
import * as functions from 'firebase-functions'
import {startOfWeek,subWeeks,format} from 'date-fns';
import { toZonedTime } from 'date-fns-tz';
import { generateWeeklySummary } from './GenerateWeeklySummary.js';

export const getWeeklySummary = functions.https.onCall(async(data)=>{

    if(!data.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed")
    }

    const today = toZonedTime(new Date(), 'Asia/Kuala_Lumpur');
    const startOfThisWeek = startOfWeek(today , {weekStartsOn:1})
    const startOfLastWeek = subWeeks(startOfThisWeek,1)
    const weeklySummaryDocId = format(startOfLastWeek , "yyyy-MM-dd")

    const userId = data.auth.uid;

    const database = admin.firestore()
    const userRef = database.collection('users').doc(userId)
    const weeklySummarySnapshot = await userRef.collection('weeklySummary').doc(weeklySummaryDocId).get()
    try{
        if(weeklySummarySnapshot.exists){
            return{
                success:true,
                message:"Successfully retrieved user's weekly summary. Already in database",
                data:{
                    ...weeklySummarySnapshot.data()
                }
            }
        }
        const weeklySummary = await generateWeeklySummary(userId , startOfLastWeek)
        return weeklySummary
    }
    catch(err){
        throw new functions.https.HttpsError("internal" , err.message)
    }
})
