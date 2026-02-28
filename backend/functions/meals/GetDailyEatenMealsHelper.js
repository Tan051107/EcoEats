import admin from '../utils/firebase-admin.cjs'
import { formatInTimeZone } from "date-fns-tz";

export async function getDailyEatenMealsHelper(userId , date){
    const todayDate = formatInTimeZone(
        date,
        "Asia/Kuala_Lumpur",
        "yyyy-MM-dd"
    )
    const database = admin.firestore()
    try{
        const userRef = database.collection('users').doc(userId)
        const mealsSnapshot = await userRef.collection('meals').where('date' , '==' , todayDate)
                                                               .orderBy('created_at' ,'asc')
                                                               .get()

        const userDailyEatenMealsData = mealsSnapshot.docs.map(doc=>{
            const createdAtTimestamp = doc.data().created_at;
            const eatenAtTime = createdAtTimestamp.toDate();
            const formattedEatenAtTime = formatInTimeZone(
                eatenAtTime,
                "Asia/Kuala_Lumpur",
                "hh:mm a"
            )
            return ({
                meal_id:doc.id,
                ...doc.data(),
                eaten_at:formattedEatenAtTime
            })
        })

        return{
            userId:userId,
            success:true,
            message: "Successfully retrieved user daily eaten meals",
            data:userDailyEatenMealsData
        }
    }
    catch(err){
        throw new Error(`Failed to get user daily eaten meals:${err.message}` , {cause:err})
    }
}