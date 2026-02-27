import admin from '../utils/firebase-admin.cjs'
import {format} from 'date-fns'

export async function getDailyEatenMealsHelper(userId , date){
    const todayDate = format(date,"yyyy-MM-dd")
    const database = admin.firestore()
    try{
        const userRef = database.collection('users').doc(userId)
        const mealsSnapshot = await userRef.collection('meals').where('date' , '==' , todayDate)
                                                               .orderBy('created_at' ,'asc')
                                                               .get()

        const userDailyEatenMealsData = mealsSnapshot.docs.map(doc=>{
            const createdAtTimestamp = doc.createTime;
            const eatenAtTime = createdAtTimestamp.toDate;
            const formattedEatenAtTime = format(eatenAtTime,'hh:mm a');
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