import ai from "./VertexAIClient.js";
import { SchemaType } from "@google/generative-ai";
import getImageMimeType from "../utils/getImageMimeType.js";

export async function getExpiryDateAndPackagingMaterialsFromAI(images){
    const allowedImageTypes = ["images/jpeg" , "images/png"]

    const schema = {
        type:SchemaType.OBJECT,
        properties:{
            expiry_found:{
                type:SchemaType.BOOLEAN,
                description:"Set to true if visible , else set to false."
            },
            expiry_date_raw:{
                type:SchemaType.STRING,
                description: 'Raw expiry date that is labelled. Set to "" if not visible.'
            },
            expiry_date_iso:{
                type:SchemaType.STRING,
                description: 'Expiry date in ISO format. Set to "" if not visible.'
            },
            date_type:{
                type:SchemaType.STRING , 
                enum:["EXP" , "BEST_BEFORE" ,"USE_BY" , "UNKNOWN"],
                description:"Fallback to 'UNKNOWN' if type is not clearly labeled."
            },
            packaging_materials:{
                type:SchemaType.ARRAY,
                items:{
                    type:SchemaType.OBJECT,
                    properties:{
                        name:{
                            type:SchemaType.STRING,
                            description:'The material of the packaging used to package the product. Set to "" if product could not be identified.'
                        },
                        recommendedDisposalWay:{
                            type:SchemaType.STRING,
                            description:'A sentence describing the recommended way to dispose the packaging that has such material. Set to "" if product packaging could not be identified.'
                        } 
                    },
                    required:['name' , 'recommendedDisposalWay']
                },
                description: "The packaging materials used for the product in image. Set to [] if no packaging material identified."
            },
            confidence:{type:SchemaType.NUMBER},
            notes:{type:SchemaType.STRING}
        },
        required:["expiry_found" , "expiry_date_raw" , "expiry_date_iso" , "date_type" , "confidence" , "packaging_materials"]
    }

    const prompt = `
                    You are an OCR + food packaging date extraction specialist and packaging identifier.

                    Task:
                    1. Detect whether an expiry date / best before / use by date exists on the packaging.
                        - Look for keywords like: EXP, EXPIRY, Best Before, BB, Use By, Valid Until.
                        - Ignore unrelated numbers like barcode, batch number, serial number.
                        - If multiple dates exist, pick the expiry/best before/use by date.
                    2. Identify packaging materials in the image. For each material identified, include:
                        - material (plastic, glass, metal, carton, paper, etc.)
                        - recommendedDisposalWay (how the user should dispose it)
                    3. Include confidence score for the result given.
                    `
    

    // const passedImages = images.filter(image=>allowedImageTypes.some(type === getImageMimeType(image)))
    //                             .map(image=>({
    //                                 fileData:{
    //                                     fileUri:image,
    //                                     mimeType:getImageMimeType(image),
    //                                 }
    //                             }))
    
    // const parts = [
    //     {text:prompt},
    //     ...passedImages
    // ] (used when receive image in uri)
    
    try{
        const result = await ai.models.generateContent({
            model:'gemini-2.0-flash',
            contents:[
                {
                    role:"user",
                    parts:[
                        {text:prompt},
                        images.map(image=>(
                            {
                                inline
                            }
                        )),
                    ],
                    //parts:parts (used when receive image in uri)
                }
            ],
            config:{
                responseMimeType:'application/json',
                responseJsonSchema:schema
            }
        })

        const resultString = result.text;

        if(!resultString){
            return{
                success:false,
                message:"Didn't receive response from Gemini",
                data:{}
            }
        }

        const finalResult = JSON.parse(resultString)
        
        return{
            success:true,
            message:"Successfully received expiry date and packaging materials from Gemini",
            data:finalResult
        }
    }
    catch(err){
        return{
            success:false,
            message:"Failed to send request to retrieve expiry date and packaging materials from Gemini" + err.message,
            data:{}
        }
    }
}

