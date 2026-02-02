 import ai from '../utils/VertexAIClient.js'
import {SchemaType} from '@google/generative-ai'
import { getAllRecipes } from '../../recipes/GetAllRecipesHelper.js'
import { addRecipes } from '../../utils/import-data/AddRecipes.js'

export async function generateMealPlansWithAI(availableGroceries , dailyCalorieIntake , dietType , userTakenRecipes , allergies){
    const scheme = {
        type:SchemaType.OBJECT,
        properties:{
            breakfast:{
                type:SchemaType.OBJECT,
                properties:{
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
                required:["allergens" , "diet_type" , "ingredients" , "nutrition" , "steps"]
            },
            lunch:{
                type:SchemaType.OBJECT,
                properties:{
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
                        type:SchemaType.OBJECT,
                        items:{
                            type:SchemaType.STRING
                        }
                    },
                },
                required:["allergens" , "diet_type" , "ingredients" , "nutrition" , "steps"]
            },
            dinner:{
                type:SchemaType.OBJECT,
                properties:{
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
                        type:SchemaType.OBJECT,
                        items:{
                            type:SchemaType.STRING
                        }
                    }
                },
                required:["allergens" , "diet_type" , "ingredients" , "nutrition" , "steps"]
            },
            totalCalories:{
                type:SchemaType.NUMBER
            },
            groceriesUsed:{
                type:SchemaType.STRING
            }, 
        },

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
                   `
    
    try{
        const response = await ai.models.generateContent({
            model: "model:'gemini-2.0-flash",
            contents:{text:prompt}
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

        const exisitingRecipesData = existingRecipes.data.map(recipe=>recipe.name)

        const generatedRecipes = [finalResult.breakfast , finalResult.lunch , finalResult.dinner]

        const newRecipes = generatedRecipes.filter(recipe=>!exisitingRecipesData.includes(recipe.name))

        addRecipes(newRecipes)

        return{
            success:true,
            message:"Successfully received daily meals from Gemini",
            data:finalResult
        }

    }
    catch(err){
        return{
            success:false,
            messsage:err.messsage,
            data:{}
        }
    }
}