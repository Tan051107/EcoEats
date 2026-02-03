import { getUserDailyMealPlan } from "./getUserDailyMealPlan.js";
import { getAllUsersData } from "../../utils/GetAllUsersData.js";
import { getAllRecipes } from "../../recipes/GetAllRecipesHelper.js";
import { addUserDailyMealPlan } from "./AddUserMealDailyMealPlan.js";
import admin from '../../utils/firebase-admin.cjs'

export async function getAllUsersDailyMealPlan(){
    const database = admin.firestore();
    let batch = database.batch()
    let batchCount = 0
    try{
        const [usersData,recipesData] = await Promise.all([
            await getAllUsersData(),
            await getAllRecipes()
        ])
        if(!usersData.success){
            return usersData
        }

        for (const userData of usersData.data){
            const userMealPlan = await getUserDailyMealPlan(userData , recipesData)
            addUserDailyMealPlan(batch,userData.userId,userMealPlan)
            batchCount++;
            if(batchCount === 450){ //only allow max of 450 batch commit
                await batch.commit();
                batch = database.batch()
                batchCount =0
            }
        }

        if(batchCount > 0){
            await batch.commit();
        }

        return{
            success:true,
            message:"Successfully added meal recommendation to all users"
        }
       
    }
    catch(err){
        return{
            success:false,
            message:err.message,
        }
    }
}