import { SchemaType } from '@google/generative-ai'
import ai from './VertexAIClient.js'

export async function analyzeGroceryImageWithAI(image){

        const schema = {
            type: SchemaType.OBJECT,
            properties: {
                name:{
                    type:SchemaType.STRING,
                    description:'The product name. Set to "" if not visible.'
                },
                calories: { 
                    type: SchemaType.NUMBER,
                    description:'The calories labelled or estimated. Set to 0 if not visible.'
                },
                fat_g: { 
                    type: SchemaType.NUMBER,
                    description:'The fats labelled or estimated. Unit in gram. Set to 0 if could not be identified.'
                },
                carbohydrates_g: { 
                    type: SchemaType.NUMBER,
                    description:'The fats labelled or estimated. Unit in gram. Set to 0 if could not be identified.'
                },
                protein_g: { 
                    type: SchemaType.NUMBER,
                    description:'The protein labelled or estimated. Unit in gram. Set to 0 if could not be identified.'
                },
                per: { 
                    type: SchemaType.STRING, 
                    description: 'The unit of measurement for the nutritional values. Set to "" if could not be identified.'
                },
                category: { 
                    type: SchemaType.STRING, 
                    enum: ["fresh_produce" , "packaged_food" , "packaged_beverage" , ""],
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
                    },
                    description: 'The list of materials used to form the package to package the product. Omit if grocery is fresh produce.'
                },
                expiry_date:{
                    type:SchemaType.STRING,
                    description: 'The expiry_date of the product labelled on package for packaged food or beverage. Omit if grocery is fresh produce.'
                },
                estimated_shelf_life:{
                    type:SchemaType.STRING,
                    description: 'Estimated shelf life in days for fresh produce (fruit or vegetable). Omit if grocery is not fresh produce.'
                },
                is_packaged:{
                    type:SchemaType.BOOLEAN,
                    description: 'To indicate whether the grocery is packaged. Set to true if is packaged, else set to false'
                },
                confidence: { type: SchemaType.NUMBER }
            },
            required: ["per" , "name","calories", "fat_g", "carbohydrates_g", "protein_g", "category", "confidence" , "is_packaged"]
        };

        const prompt = `
                                You are a grocery product analysis assistant.

                                Task
                                1. Identify the item and classify it as "fresh_produce", "packaged_food", or "packaged_beverage".
                                2. EXTRACT visible nutrition/expiry data from packaged food or packaged beverage.
                                3. ESTIMATE standard nutritional values for fresh produce or unlabeled items based on a common serving size (set in 'per').

                                Logic Rules
                                For fresh produced:
                                - Set is_packaged=false. 
                                - Include 'estimated_shelf_life'. 
                                - Omit 'packaging' and 'expiry_date'.
                                For packaged food or packaged drinks:
                                - Set is_packaged=true.
                                - Include packaging materials. For each packaging material, include:
                                    -material (plastic, glass, metal, carton, paper, etc.)
                                    - recommendedDisposalWay (how the user should dispose it) and. 
                                - Include 'expiry_date' ONLY if clearly visible.
                                - NUTRITION: If values aren't visible, provide realistic estimates for the item shown.        
                                 `
        
        try{
            const response = await ai.models.generateContent({
                model:'gemini-2.0-flash',
                contents:[
                    {
                        role:"user",
                        parts:[
                            {
                                inlineData:{
                                    mimeType:"image/png",
                                    data:image
                                }
                            },
                            {text:prompt}
                        ]
                    }
                ],
                config:{
                    responseMimeType:"application/json",
                    responseJsonSchema:schema
                }
            })

            if(!response){
                return{
                    success:false,
                    message:"No response received from Gemini.",
                    data:{}
                }
            }

            const responseString = response.text;

            const result = JSON.parse(responseString)

            return{
                success:true,
                message:"Successfully retrieved grocery analysis.",
                data:result
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