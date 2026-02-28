import ai from './VertexAIClient.js'
import { SchemaType } from '@google/generative-ai'
import * as functions from 'firebase-functions'
import {storeNewPackageMaterials} from './StoreNewPackageMaterial.js'
import admin from '../utils/firebase-admin.cjs'


export const getEstimatedMealNutrition = functions.https.onCall(async(request)=>{

    const bucket = admin.storage().bucket();

    if(!request.auth){
        throw new functions.https.HttpsError('unauthenticated' , "Please login to proceed")
    }

    const {images} = request.data;


    const schema = {
        type:SchemaType.OBJECT,
        properties:{
            name:{
                type:SchemaType.STRING,
                description: 'The name of the food or beverage'
            },
            nutrition:{
                type:SchemaType.OBJECT,
                description:"The nutrition values of the meal",
                properties:{
                    calories_kcal: { 
                        type: SchemaType.NUMBER,
                        description:'The calories estimated in kcal. Set to 0 if not visible.'
                    },
                    fat_g: { 
                        type: SchemaType.NUMBER,
                        description:'The fats estimated. Unit in gram. Set to 0 if could not be identified.'
                    },
                    carbs_g: { 
                        type: SchemaType.NUMBER,
                        description:'The carbohydrates estimated. Unit in gram. Set to 0 if could not be identified.'
                    },
                    protein_g: { 
                        type: SchemaType.NUMBER,
                        description:'The protein estimated. Unit in gram. Set to 0 if could not be identified.'
                    },
                },
                required:["calories_kcal" , "fat_g" , "carbs_g" , "protein_g"]   
            },
            serving_size:{
                type:SchemaType.STRING,
                description:'serving size of the food and beverage. Set to "" if could not be identified'
            },
            packaging_materials: {
                type: SchemaType.ARRAY,
                items: {
                    type: SchemaType.OBJECT,
                    properties: {
                        name: { 
                            type: SchemaType.STRING,
                            description:'The material of the packaging used to package the food or beverage. Set to "" if materials could not be identified.'
                        },
                        recommendedDisposalWay: { 
                            type: SchemaType.STRING,
                            description:'Describe in a sentence the recommended way to dispose the packaging that has such material.Set to "" if materials could not be identified.'
                        }
                    },
                    required:['name' , 'recommendedDisposalWay']
                },
                description: 'The list of materials used to form the package to package the food or beverage. Set to [] if no packaging.'
            },
            healthy_score:{
                type:SchemaType.STRING,
                enum:["High" , "Medium" , "Low"],
                description:'Health rating on the food or beverage. Set to "" if could not identify the food/beverage.'
            },
            comment:{
                type:SchemaType.STRING,
                description: 'A brief, encouraging comment or a tip for improvement. Set to "" if could not identify food.'
            },
            confidence:{
                type:SchemaType.NUMBER
            }
        },
        required:["name","nutrition", "serving_size", "healthy_score" , "comment" , "confidence"]
    }
    
    const prompt = `
                        You are a professional nutritionist and sustainability expert. Your task is to analyze the provided image of a meal or beverage and provide a detailed nutritional and packaging breakdown.

                        Task
                        1. Identify the main food or beverage items.
                         - Analyze portion sizes relative to standard plates or utensils in the image.
                         - Identify any packaging materials visible (e.g., plastic containers, paper wraps, aluminum foil).
                        
                        2. Estimate its portion size and nutritional values.
                            - If the item is a common branded product, use its known nutritional profile.
                            - If it is a cooked meal, estimate based on standard ingredients.
                        
                        3. Evaluate the packaging
                            - For each material identified, provide a clear, one-sentence instruction on the most eco-friendly disposal method (e.g., "Rinse and place in the blue recycling bin").
                        
                        4. Evaluate the food or beverage
                            - Assign a health rating (High, Medium, or Low) based on nutrient density.
                            - Provide a brief, encouraging comment or a tip for improvement (e.g., "High in protein! Consider adding more greens for fiber.").
                        
                        5. Include confidence (0-100) for the result given.
                   `
    
    let imagesToUri = [];
    const imagesWithMimeType = await Promise.all(
    images.map(async (image) => {
        try {
        const file = bucket.file(image);
        const [metadata] = await file.getMetadata();
        const imageUri = `gs://${bucket.name}/${image}`
        imagesToUri.push(imageUri);
        return {
            imageUri: imageUri,
            mimeType: metadata?.contentType || ""
        };
        } catch (err) {
        console.error("Metadata error:", image, err);
        return null;
        }
    })
    );
    
    
    const validImages = imagesWithMimeType.filter(Boolean);

    const parts = [
        {text: prompt},
        ...validImages.map(img => ({
            fileData:{
                fileUri: img.imageUri,
                mimeType: img.mimeType
            }
        })),
    ];
    
    try{
        const response =  await ai.models.generateContent({
            model:"gemini-2.0-flash",
            contents:{
                role:"user",
                parts:[
                    parts
                ]
            },
            config:{
                responseMimeType:"application/json",
                responseJsonSchema:schema
            }
        })

        const resultString = response.text

        if(!resultString){
            return{
                success:false,
                message:"Didn't receive response from Gemini",
                data:{}
            }
        }

        const finalResult = JSON.parse(resultString)

        const storeNewPackagingResponse = await storeNewPackageMaterials(finalResult.packaging_materials);
        return{
            success:true,
            storeNewPackagingResponse: storeNewPackagingResponse.message,
            message:"Successfully received estimated meal nutrition from Gemini.",
            data:{
                ...finalResult,
                image_urls:imagesToUri
            }
        }
    }
    catch(err){
        throw new Error(`Failed to receive estimated meal nutrition from Gemini:${err.message}` , {cause:err})
    }
})
