import ai from "./VertexAIClient.js";
import { SchemaType } from "@google/generative-ai";

export async function getExpiryDateFromAI(image){
    try{
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
                confidence:{type:SchemaType.NUMBER},
                notes:{type:SchemaType.STRING}
            },
            required:["expiry_found" , "expiry_date_raw" , "expiry_date_iso" , "date_type" , "confidence"]
        }
        const prompt = `
                        You are an OCR + food packaging date extraction assistant.

                        Goal:
                        Detect whether an expiry date / best before / use by date exists on the packaging.

                        Instructions:
                        - Look for keywords like: EXP, EXPIRY, Best Before, BB, Use By, Valid Until.
                        - Ignore unrelated numbers like barcode, batch number, serial number.
                        - If multiple dates exist, pick the expiry/best before/use by date.
                        - Include confidence (0-100) for the result given.
                        `
        const result = await ai.models.generateContent({
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
            message:"Successfully received expiry date from Gemini",
            data:finalResult
        }
    }
    catch(err){
        return{
            success:false,
            message:"Failed to send request to retrieve expiry date" + err.message,
            data:{}
        }
    }
}