import ai from './VertexAIClient.js'
import { SchemaType } from '@google/generative-ai';


export async function organizePackagedNutritionalLabelFromImage(nutritionLabel){
    try{
        const schema = {
            type: SchemaType.OBJECT,
            properties: {
                name:{type:SchemaType.STRING},
                calories: { type: SchemaType.NUMBER },
                fat_g: { type: SchemaType.NUMBER },
                carbohydrates_g: { type: SchemaType.NUMBER },
                protein_g: { type: SchemaType.NUMBER },
                per: { 
                type: SchemaType.STRING, 
                enum: ["serving", "100g", ""] 
                },
                category: { 
                type: SchemaType.STRING, 
                enum: ["food", "beverage", ""] 
                },
                packaging: {
                type: SchemaType.ARRAY,
                items: {
                    type: SchemaType.OBJECT,
                    properties: {
                    material: { type: SchemaType.STRING },
                    recommendedDisposalWay: { type: SchemaType.STRING }
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
                        5. If a value is missing, set it to "".
                        6. Only return JSON. Do not include any explanations, markdown, or extra text.

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