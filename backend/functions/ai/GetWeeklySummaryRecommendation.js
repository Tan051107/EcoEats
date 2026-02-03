import ai from './VertexAIClient.js'
import { SchemaType } from '@google/generative-ai'
export async function getWeeklySummaryRecommendations(weeklySummary ,goal, activityLevel , weight , height , age , gender){

    const schema = {
        type:SchemaType.ARRAY,
        items:{
            type:SchemaType.STRING,
            description: 'Provide a brief, encouraging comment or a tip for improvement (e.g., "High in protein! Consider adding more greens for fiber.").'
        }
    }
    
    const {each_day_summary,average_daily_calories_kcal,average_daily_protein_g,average_daily_fat_g, average_daily_carbs_g, daily_calorie_intake_kcal} = weeklySummary

    const prompt =`
                    You are a nutrition analysis assistant.

                    Based on the following user details and nutrition data, analyze intake trends and provide 3 high-level and actionable meal recommendations.

                    User details:
                    1. Goal:${goal}
                    2. Activity Level:${activityLevel},
                    3. Weight (kg): ${weight},
                    4. Height (cm): ${height},
                    5. Age: ${age},
                    6. Gender: ${gender}

                    User meal details:
                    1. Daily meal summary: ${each_day_summary},
                    2. Average daily calories (kcal): ${average_daily_calories_kcal},
                    3. Average daily protein (g): ${average_daily_protein_g},
                    4. Average daily carbohydrates(g): ${average_daily_carbs_g},
                    5. Average daily fats (g): ${average_daily_fat_g}
                    6. Daily needed calorie intake (kcal): ${daily_calorie_intake_kcal} 
                  `
    try{
        const response = await ai.models.generateContent({
            model:"gemini-2.0-flash",
            contents:{text:prompt},
            config:{
                responseMimeType:"application/json",
                responseJsonSchema:schema
            }
        })

        const resultString = response.text;

        if(!resultString){
            return{
                success:false,
                message:"Didn't receive recommendation from Gemini.",
                data:[]
            }
        }

        const finalResult = JSON.parse(resultString)

        return{
            success:false,
            message:"Successfully received weekly summary recommendations from Gemini.",
            data:finalResult
        }
    }
    catch(err){
        throw new Error("Failed to receive weekly summary recommendations from Gemini." , {cause:err})
    }

}

