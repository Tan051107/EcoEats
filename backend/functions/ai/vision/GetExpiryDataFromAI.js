import ai from "./VertexAIClient.js";


export async function getExpiryDateFromAI(image){
    try{
        const prompt = `
                        You are an OCR + food packaging date extraction assistant.

                        Goal:
                        Detect whether an expiry date / best before / use by date exists on the packaging.

                        Instructions:
                        - Look for keywords like: EXP, EXPIRY, Best Before, BB, Use By, Valid Until.
                        - Ignore unrelated numbers like barcode, batch number, serial number.
                        - If multiple dates exist, pick the expiry/best before/use by date.
                        - If no expiry/best before/use by date is visible, set "expiry_found": false and leave other fields empty , else set "expiry_found":true.
                        - If date is unclear but likely present, set "expiry_found":true with confidence LOW.

                        Return ONLY valid JSON:
                        {
                        "expiry_found": true,
                        "expiry_date_raw": "",
                        "expiry_date_iso": "",
                        "date_type": "EXP|BEST_BEFORE|USE_BY|UNKNOWN",
                        "confidence": "HIGH|MEDIUM|LOW",
                        "notes": ""
                        }
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
                responseMimeType:'application/json'
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