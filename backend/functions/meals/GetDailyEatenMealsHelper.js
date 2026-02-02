import admin from '../utils/firebase-admin.cjs'

export async function getDailyEatenMealsHelper(userId , date){
    const startofToday = new Date(date.getFullYear(),date.getMonth(),date.getDate())
    const endofToday = new Date(date.getFullYear(),date.getMonth(),date.getDate()+1)
    const database = admin.firestore()
    try{
        const userRef = database.collection('users').doc(userId)
        const mealsSnapshot = await userRef.collection('meals').where('date' , '>=' , admin.firestore.Timestamp.fromDate(startofToday))
                                                     .where('date' , '<' , admin.firestore.Timestamp.fromDate(endofToday))
                                                     .get()

        const userDailyEatenMealsData = mealsSnapshot.docs.map(doc=>({
            mealId:doc.id,
            ...doc.data()
        }))

        return{
            success:true,
            message: "Successfully retrieved user daily eaten meals",
            data:userDailyEatenMealsData
        }
    }
    catch(err){
        return{
            success:false,
            message:err.message,
            data:[]
        }
    }
}