import { getAllUsersDailyMealPlan } from "./GetAllUsersDailyMealPlan.js";
import { onSchedule } from "firebase-functions/scheduler";

export const scheduleRecommendDailyMeals = onSchedule({
    schedule:"0 3 * * *", //runs at every day 3 am,
    region:"Asia/Kuala_Lumpur",
    memory: "512MiB",
    timeoutSeconds: 120,
    retryCount:1},
    async (event) => {
        try{
            console.log("Generating meal recommendation for all users");
            const result = await getAllUsersDailyMealPlan();
            if(!result.success){
                console.error(result.message)
            } 
        } 
        catch(err){
            console.error("Failed to schedule daily meal recommendations" , err.message)
        }  
    }
)