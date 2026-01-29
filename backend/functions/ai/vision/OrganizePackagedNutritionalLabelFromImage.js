import ai from './VertexAIClient.js'
import { SchemaType } from '@google/generative-ai';


export async function organizePackagedNutritionalLabelFromImage(nutritionLabel){
    try{
        const schema = {
            type: SchemaType.OBJECT,
            properties: {
                name:{
                    type:SchemaType.STRING,
                    description:'The product name. Set to "" if not visible.'
                },
                calories: { 
                    type: SchemaType.NUMBER,
                    description:'The calories labelled. Set to 0 if not visible.'
                },
                fat_g: { 
                    type: SchemaType.NUMBER,
                    description:'The fats labelled. Unit in gram. Set to 0 if not visible.'
                },
                carbohydrates_g: { 
                    type: SchemaType.NUMBER,
                    description:'The fats labelled. Unit in gram. Set to 0 if not visible.'
                },
                protein_g: { 
                    type: SchemaType.NUMBER,
                    description:'The protein labelled. Unit in gram. Set to 0 if not visible.'
                },
                per: { 
                    type: SchemaType.STRING, 
                    description: 'The unit of measurement for the nutritional values. Set to "" if not visible'
                },
                category: { 
                    type: SchemaType.STRING, 
                    enum: ["packaged_food", "packaged_beverage", ""],
                    description: 'The category of the product. Set to "" if product could not be identified.'
                },
                packaging: {
                    type: SchemaType.ARRAY,
                    items: {
                        type: SchemaType.OBJECT,
                        properties: {
                        material: { 
                            type: SchemaType.STRING,
                            description:'The material of the packaging used to package the product. Set to "" if product could not be identified.'
                        },
                        recommendedDisposalWay: { 
                            type: SchemaType.STRING,
                            description:'The recommended way to dispose the packaging that has such material. Return in a sentence. Set to "" if product packaging could not be identified.'
                        }
                        },
                        required:['material' , 'recommendedDisposalWay']
                    }
                },
                confidence: { type: SchemaType.NUMBER }
            },
            required: ["per" , "name","calories", "fat_g", "carbohydrates_g", "protein_g", "category", "confidence" , "packaging"]
            };

        const prompt = `You are a specialized nutrition and packaging parser.

                        I will give you the raw OCR text extracted from a product's nutrition label.

                        Task:
                        1. Extract nutrition info from the OCR text below into JSON with keys:
                        - Include the following keys exactly: 
                        - calories in kcal
                        - fat_g
                        - carbs_g
                        - protein_g
                        - per
                        2. Also include product name and category.
                        3. Include packaging materials. For each packaging material, include:
                                - material (plastic, glass, metal, carton, paper, etc.)
                                - recommendedDisposalWay (how the user should dispose it)
                        4. Include confidence (0-100) for the result given.

                        OCR TEXT: ${nutritionLabel}
                        `
        const result = await ai.models.generateContent(
            {
                model:'gemini-2.0-flash',
                contents:prompt,
                config:{
                    responseMimeType:"application/json",
                    responseJsonSchema:schema
                }
            }
        )

        const JsonString = result.text
        if(!JsonString){
            return{
                success:false,
                message:"No result returned by Gemini",
                data:{}
            }
        }

        const finalResult = JSON.parse(JsonString)

        return{
            success:true,
            message:"Successfully retrieved nutrition info from Gemini",
            data:finalResult
        }
    }
    catch(err){
        return{
            success:false,
            message:err.message,
            data:{}
        }
    }
}