import { generateDailyMealPlan } from "./GenerateDailyMealPlan.js";
import { getAllUsersData } from "../utils/GetAllUsersData.js";
import { getAllRecipes } from "../utils/GetAllRecipes.js";

export async function generateDailyMealPlanAllUsers(){
    try{
        const [usersData,recipesData] = await Promise.all([
            await getAllUsersData(),
            await getAllRecipes()
        ])
        if(!usersData.success){
            return usersData
        }

        for (const userData of usersData.data){
            await generateDailyMealPlan(userData , recipesData)
        }
       
    }
    catch(err){
        return{
            success:false,
            message:err.message,
        }
    }
}