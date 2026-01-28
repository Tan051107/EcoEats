import visionClient from './VisionClient.js'


export async function getExpiryDate(image){
    try{
        const [response] = await visionClient.annotateImage({
            image: {
                content: image, // Cloud Vision accepts the base64 string here
            },
            features: [{ type: 'TEXT_DETECTION' }],
        });

        const result = response.textAnnotations;

        if (result.length == 0 || !result){
            return{
                success:false,
                error: "No text detected"
            }
        }

        const textDetected = result[0].description

        // Matches patterns like DD/MM/YYYY, MM-DD-YY, or 2026.05.12
        const dateRegex = /\b(\d{1,2}[-/\.]\d{1,2}[-/\.]\d{2,4})\b/g;
        
        // Matches patterns like "EXP JAN 2026" or "BB 12/26"
        const keywordRegex = /(?:EXP|BB|BEST BEFORE|USE BY)[:\s]*([A-Z]{3,9}\s\d{2,4}|\d{1,2}[-/\.]\d{1,2}[-/\.]\d{2,4})/gi;

        const foundDates = textDetected.match(dateRegex) || []
        const foundKeywordDates = [...textDetected.matchAll(keywordRegex)].map(match=>match[1])

        const matches = [...new Set([...foundDates , ...foundKeywordDates])]

        if(!Array.isArray(matches) || matches.length === 0){
            return {
                success:false,
                error:"No expiry date detected",
                textDetectionResult:textDetected
            }
        }

        return{
            success:true,
            matches:"Matches" + matches,
            textDetectionResult:"Text Detected" + textDetected
        }
    }
    catch(err){
        return{
            success:false,
            error:err.message
        }
    }
}