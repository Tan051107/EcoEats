import ai from './VertexAIClient.js'
import {SchemaType} from '@google/generative-ai'
import { getAllRecipes } from '../recipes/GetAllRecipesHelper.js'
import {addRecipes} from '../recipes/AddRecipe.js'

export async function generateMealPlansWithAI(availableGroceries , dailyCalorieIntake , dietType , userTakenRecipes , allergies){
    const schema = {
        type:SchemaType.OBJECT,
        properties:{
            breakfast:{
                type:SchemaType.OBJECT,
                properties:{
                    name:{
                        type:SchemaType.STRING
                    },                  
                    allergens:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.STRING
                        }
                    },
                    diet_type:{
                        type:SchemaType.STRING,
                        enum:["non-vegetarian" , "vegetarian" , "vegan"]
                    },
                    ingredients:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.OBJECT,
                            properties:{
                                name:{
                                    type:SchemaType.STRING,
                                },
                                quantity:{
                                    type:SchemaType.STRING
                                }
                            },
                            required:[name,quantity]
                        }
                    },
                    nutrition:{
                        type:SchemaType.OBJECT,
                        properties:{
                            calories_kcal:{
                                type:SchemaType.NUMBER
                            },
                            carbs_g:{
                                type:SchemaType.NUMBER
                            },
                            fat_g:{
                                type:SchemaType.NUMBER
                            },
                            protein_g:{
                                type:SchemaType.NUMBER
                            },
                        }
                    },
                    steps:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.STRING
                        }
                    }
                },
                required:["name" , "allergens" , "diet_type" , "ingredients" , "nutrition" , "steps"]
            },
            lunch:{
                type:SchemaType.OBJECT,
                properties:{
                    name:{
                        type:SchemaType.STRING
                    },
                    allergens:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.STRING
                        }
                    },
                    diet_type:{
                        type:SchemaType.STRING,
                        enum:["non-vegetarian" , "vegetarian" , "vegan"]
                    },
                    ingredients:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.OBJECT,
                            properties:{
                                name:{
                                    type:SchemaType.STRING,
                                },
                                quantity:{
                                    type:SchemaType.STRING
                                }
                            },
                            required:[name,quantity]
                        }
                    },
                    nutrition:{
                        type:SchemaType.OBJECT,
                        properties:{
                            calories_kcal:{
                                type:SchemaType.NUMBER
                            },
                            carbs_g:{
                                type:SchemaType.NUMBER
                            },
                            fat_g:{
                                type:SchemaType.NUMBER
                            },
                            protein_g:{
                                type:SchemaType.NUMBER
                            },
                        }
                    },
                    steps:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.STRING
                        }
                    },
                },
                required:["name" , "allergens" , "diet_type" , "ingredients" , "nutrition" , "steps"]
            },
            dinner:{
                type:SchemaType.OBJECT,
                properties:{
                    name:{
                        type:SchemaType.STRING
                    },
                    allergens:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.STRING
                        }
                    },
                    diet_type:{
                        type:SchemaType.STRING,
                        enum:["non-vegetarian" , "vegetarian" , "vegan"]
                    },
                    ingredients:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.OBJECT,
                            properties:{
                                name:{
                                    type:SchemaType.STRING,
                                },
                                quantity:{
                                    type:SchemaType.STRING
                                }
                            },
                            required:[name,quantity]
                        }
                    },
                    nutrition:{
                        type:SchemaType.OBJECT,
                        properties:{
                            calories_kcal:{
                                type:SchemaType.NUMBER
                            },
                            carbs_g:{
                                type:SchemaType.NUMBER
                            },
                            fat_g:{
                                type:SchemaType.NUMBER
                            },
                            protein_g:{
                                type:SchemaType.NUMBER
                            },
                        }
                    },
                    steps:{
                        type:SchemaType.ARRAY,
                        items:{
                            type:SchemaType.STRING
                        }
                    }
                },
                required:["name" , "allergens" , "diet_type" , "ingredients" , "nutrition" , "steps"]
            },
            totalCalories:{
                type:SchemaType.NUMBER
            },
            missingIngredients:{
                type:SchemaType.ARRAY,
                items:{
                    type:SchemaType.OBJECT,
                    properties:{
                        mealType:{
                            type:SchemaType.STRING,
                            enum:["breakfast" , "lunch" , "dinner"],
                        },
                        missingIngredients:{
                            type:SchemaType.STRING,
                            description: "List of ingredients for that meal that are not available in available groceries. Set to [] if all ingredients needed are in available groceries"
                        }
                    }
                }
            }
        },
        required:["breakfast" , "lunch" , "dinner" , "totalCalories" ,"missingIngredients" ]

    }

    const prompt = `
                       Generate a meal plan for a single day including breakfast, lunch, and dinner.

                       Available groceries: ${availableGroceries}
                       Allergens: ${allergies}
                       Diet Type: ${dietType}
                       Daily Calorie Intake: ${dailyCalorieIntake}kcal
                       User Taken Recipes: ${userTakenRecipes}

                       Requirements:
                       1. Use as much ingredients possible that is in the available groceries list.
                       2. Do not include meals which contains ingredients that is in allergens list.
                       3. Meals generated must match user's diet type.
                       4. The total calories of the three meals should be as close as possible to the daily calorie target, without exceeding it or being more than 200 kcal below it.
                       5. Do not generate meals that are in user taken recipes list.
                       6. Generate realistic meals with proper quantities, nutrition, and preparation steps.
                       7. List down the missing ingredients that are not available in available groceries for each meal.
                   `
    
    try{
        const response = await ai.models.generateContent({
            model: "model:'gemini-2.0-flash",
            contents:{
                role:"user",
                parts:[
                    {text:prompt}  
                ]
            },
            config:{
                responseMimeType:"application/json",
                responseJsonSchema:schema
            }
        })

        const resultString = response.text;

        if(!resultString){
            return{
                success:false,
                message:"Failed to receive response from Gemini.",
                data:{}
            }
        }

        const finalResult = JSON.parse(resultString)

        const existingRecipes = await getAllRecipes();

        const existingRecipesData = existingRecipes.data

        const mealTypes = ["breakfast" , "lunch" , "dinner"]

        mealTypes.forEach(meal=>{
            finalResult?.[meal] && (finalResult[meal].meal_type = meal);
        })

        const generatedRecipes = [finalResult.breakfast , finalResult.lunch , finalResult.dinner]

        const newRecipes = generatedRecipes.filter(recipe=>!existingRecipesData.some(existingRecipe=>existingRecipe.name.toLowerCase() === recipe.name.toLowerCase()))

        const finalResultRecipes = generatedRecipes.filter(recipe=>existingRecipesData.some(existingRecipe=>existingRecipe.name.toLowerCase() === recipe.name.toLowerCase()))
        
        let newRecipesAdded = [];

        if(newRecipes.length >0){
            newRecipesAdded = await addRecipes(newRecipes)
        }

        finalResultRecipes = [...finalResultRecipes , ...newRecipesAdded.data]
        
        const finalMealPlan = finalResultRecipes.reduce((acc,curr)=>{
            acc[curr.meal_type] = curr
            return acc;
        },{})

        const finalReturnResult = {
            totalCalories:finalResult.totalCalories,
            missingIngredients:finalResult.missingIngredients,
            ...finalMealPlan
        }

        return{
            success:true,
            message:"Successfully received daily meal recommendation from Gemini",
            data:finalReturnResult
        }

    }
    catch(err){
        throw new Error("Failed to receive daily meal recommendation from Gemini" , {cause:err})
    }
}