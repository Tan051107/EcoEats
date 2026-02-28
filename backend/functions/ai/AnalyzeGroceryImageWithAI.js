    import { SchemaType } from '@google/generative-ai'
    import ai from './VertexAIClient.js'
    import { storeNewPackageMaterials } from './StoreNewPackageMaterial.js';
    import admin from '../utils/firebase-admin.cjs'
    import {format} from 'date-fns'

    export async function analyzeGroceryImageWithAI(images){

        const bucket = admin.storage().bucket();
        const today = new Date();
        const todayDate = format(today , "yyyy-MMMM-dd")

        const schema = {
            type: SchemaType.OBJECT,
            properties: {
                name:{
                    type:SchemaType.STRING,
                    description:'The product name. Set to "" if not visible.'
                },
                nutrition:{
                    type:SchemaType.OBJECT,
                    description:"The nutritions of the grocery",
                    properties:{
                        calories_kcal: { 
                            type: SchemaType.NUMBER,
                            description:'The calories labelled or estimated in kcal. Set to 0 if not visible.'
                        },
                        fat_g: { 
                            type: SchemaType.NUMBER,
                            description:'The fats labelled or estimated. Unit in gram. Set to 0 if could not be identified.'
                        },
                        carbs_g: {
                            type: SchemaType.NUMBER,
                            description:'The fats labelled or estimated. Unit in gram. Set to 0 if could not be identified.'
                        },
                        protein_g: { 
                            type: SchemaType.NUMBER,
                            description:'The protein labelled or estimated. Unit in gram. Set to 0 if could not be identified.'
                        },
                    },
                    required:["calories_kcal" , "fat_g" , "carbs_g" , "protein_g"]
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
                        required:['name' , 'recommendedDisposalWay']
                    },
                    description: 'The list of materials used to form the package to package the product. Omit if grocery is fresh produce.'
                },
                expiry_date:{
                    type:SchemaType.STRING,
                    description: 'The expiry_date of the product labelled on package for packaged food or beverage. Estimate the expiry_date if the grocery is fresh produce.'
                },
                is_packaged:{
                    type:SchemaType.BOOLEAN,
                    description: 'To indicate whether the grocery is packaged. Set to true if is packaged, else set to false'
                },
                confidence: { type: SchemaType.NUMBER }
            },
            required: ["per" , "name","nutrition", "category", "is_packaged","expiry_date"]
        };

        const prompt = `
                        You are a grocery product analysis assistant.

                        Task
                        1. Identify the item and classify it as "fresh produce", "packaged food", or "packaged beverage".
                        2. EXTRACT visible nutrition/expiry date from packaged food or packaged beverage.
                        3. ESTIMATE the expiry date for fresh produce.
                        4. Expiry date format must be in "yyyy-MM-dd".
                        5. ESTIMATE standard nutritional values for fresh produce or unlabeled items based on a common serving size (set in 'per').
                        6. Include confidence (0-100) for the result given.

                        Logic Rules
                        For fresh produced:
                        - Set is_packaged=false. 
                        - Include 'expiry_date' by estimating the expiry date of fresh produce based on today's date. Today's date is ${todayDate}
                        - Omit 'packaging'.
                        For packaged food or packaged drinks:
                        - Set is_packaged=true.
                        - Include packaging materials. For each packaging material, include:
                            - name (plastic, glass, metal, carton, paper, etc.)
                            - recommendedDisposalWay (how the user should dispose it) and. 
                        - Include 'expiry_date' ONLY if clearly visible.
                        - NUTRITION: If values aren't visible, provide realistic estimates for the item shown.        
                        `

            const imagesWithMimeType = await Promise.all(
            images.map(async (image) => {
                try {
                const file = bucket.file(image);
                const [metadata] = await file.getMetadata();

                return {
                    imageUri: `gs://${bucket.name}/${image}`,
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
            
            console.log(parts)
        
            try{
                const response = await ai.models.generateContent({
                    model:'gemini-2.0-flash',
                    contents:[
                        {
                            role:"user",
                            parts:parts
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
                
                if(result.packaging_materials != undefined){
                    await storeNewPackageMaterials(result.packaging_materials)
                }

                return{
                    success:true,
                    message:"Successfully retrieved grocery image analysis from Gemini.",
                    data:result
                }
            }
            catch(err){
                throw new Error(`Failed to get grocery image analysis from Gemini, ${err.message}` , {cause:err})
            }
            
    }