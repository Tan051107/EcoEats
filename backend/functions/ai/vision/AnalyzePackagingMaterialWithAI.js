import ai from './VertexAIClient.js';
import { SchemaType } from '@google/generative-ai';
import {storeNewPackageMaterials } from './StoreNewPackageMaterial.js';


export async function analyzePackagingMaterialWithAI(image){

    const schema = {
        type:SchemaType.OBJECT,
        properties:{
            confidence:{
                type:SchemaType.INTEGER,
            },
            packaging:{
                type:SchemaType.ARRAY,
                items:{
                    type:SchemaType.OBJECT,
                    properties:{
                        material:{
                            type:SchemaType.STRING,
                            description:'The material of the packaging used to package the product. Set to "" if product could not be identified.'
                        },
                        recommendedDisposalWay:{
                            type:SchemaType.STRING,
                            description:'A sentence describing the recommended way to dispose the packaging that has such material. Set to "" if product packaging could not be identified.'
                        }  
                    },
                    required:['material' , 'recommendedDisposalWay']
                },
                description:"The packaging materials used for the product in image. Set to [] if no packaging material identified."
            }
        },
        required:['confidence' , 'packagings']
    }

    const prompt = `
                    You are a specialized packaging identifier.

                    Task
                    1. Identify packaging materials in the image. 
                    2. For each material identified, include:
                        - material (plastic, glass, metal, carton, paper, etc.)
                        - recommendedDisposalWay (how the user should dispose it)
                    3. Include confidence score for the result given.
                    `
    try{
        const response = await ai.models.generateContent({
            model:"gemini-2.0-flash",
            contents:[
                {
                    role:"user"
                },
                {
                    parts:[
                        {
                            inlineData:{
                                mimeType:"image/png",
                                data:image
                            },
                            
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

        const resultString = response.text;

        if(!resultString){
            return{
                success:false,
                message:"Didn't able to receive packaging material result from Gemini",
                data:[]
            }
        }

        const finalResult = JSON.parse(resultString);

        await storeNewPackageMaterials(finalResult);

        return{
            success:true,
            message:"Successfully receive packaging material result from Gemini",
            data:finalResult
        }

    }
    catch(err){
        return{
            success:false,
            message:err.message,
            data:[]
        }
    }
}

