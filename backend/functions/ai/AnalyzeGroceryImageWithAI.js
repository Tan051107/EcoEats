    import { SchemaType } from '@google/generative-ai'
    import ai from './VertexAIClient.js'
    import { storeNewPackageMaterials } from './StoreNewPackageMaterial.js';
    import getImageMimeType from '../utils/getImageMimeType.js';

    export async function analyzeGroceryImageWithAI(images){

        const allowedImageTypes = ["images/png" , "images/jpeg"]

        const schema = {
            type: SchemaType.OBJECT,
            properties: {
                name:{
                    type:SchemaType.STRING,
                    description:'The product name. Set to "" if not visible.'
                },
                calories_kcal: { 
                    type: SchemaType.NUMBER,
                    description:'The calories labelled or estimated in kcal. Set to 0 if not visible.'
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
                    enum: ["fresh produce" , "packaged food" , "packaged beverage" , ""],
                    description: 'The category of the product. Set to "" if product could not be identified.'
                },
                packaging_materials: {
                    type: SchemaType.ARRAY,
                    items: {
                        type: SchemaType.OBJECT,
                        properties: {
                        name: { 
                            type: SchemaType.STRING,
                            description:'The material of the packaging used to package the product. Set to "" if product could not be identified.'
                        },
                        recommendedDisposalWay: { 
                            type: SchemaType.STRING,
                            description:'Describe in a sentence the recommended way to dispose the packaging that has such material.Set to "" if product packaging could not be identified.'
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
            required: ["per" , "name","calories_kcal", "fat_g", "carbohydrates_g", "protein_g", "category", "confidence" , "is_packaged"]
        };

        const prompt = `
                        You are a grocery product analysis assistant.

                        Task
                        1. Identify the item and classify it as "fresh produce", "packaged food", or "packaged beverage".
                        2. EXTRACT visible nutrition/expiry data from packaged food or packaged beverage.
                        3. ESTIMATE standard nutritional values for fresh produce or unlabeled items based on a common serving size (set in 'per').
                        4. Include confidence (0-100) for the result given.

                        Logic Rules
                        For fresh produced:
                        - Set is_packaged=false. 
                        - Include 'estimated_shelf_life'. 
                        - Omit 'packaging' and 'expiry_date'.
                        For packaged food or packaged drinks:
                        - Set is_packaged=true.
                        - Include packaging materials. For each packaging material, include:
                            - name (plastic, glass, metal, carton, paper, etc.)
                            - recommendedDisposalWay (how the user should dispose it) and. 
                        - Include 'expiry_date' ONLY if clearly visible.
                        - NUTRITION: If values aren't visible, provide realistic estimates for the item shown.        
                        `
            // const imageParts = images.filter(image=> allowedImageTypes.some(type=>type === getImageMimeType(image)))
            //                          .map(image=>({
            //                             fileData:{
            //                                 fileUri:image,
            //                                 mimeType:getImageMimeType(image)
            //                             }
            //                          }))
            
            // const parts = [
            //     {text:prompt},
            //     ...imageParts
            // ] //(used when receive image in uri)
        
            try{
                const response = await ai.models.generateContent({
                    model:'gemini-2.0-flash',
                    contents:[
                        {
                            role:"user",
                            parts:[
                                {
                                    inlineData:{
                                        mimeType:"image/jpeg",
                                        data:images
                                    }
                                },
                                {text:prompt}
                            ],
                            //parts:parts (used when receive image in uri)
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

                await storeNewPackageMaterials(result.packaging_materials)

                return{
                    success:true,
                    message:"Successfully retrieved grocery analysis.",
                    data:result
                }
            }
            catch(err){
                throw new Error("Failed to get grocery image analysis from Gemini" , {cause:err})
            }
            
    }