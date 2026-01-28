import visionClient from "./VisionClient.js";

export async function getPackagedNutritionLabelFromImage(image){
    try{
        const [response] = await visionClient.annotateImage(
            {
                image:{
                    content:image
                },
                features:[
                    {type:"TEXT_DETECTION"}
                ]
            }
        )

        if(!response){
            return{
                success:false,
                message:"Failed to receive response from vision AI",
                data:""
            }
        }

        const result = response?.fullTextAnnotation.text;

        const normalizedResult = result.replace(/[ \t]+/g , " ") //to replace when more than 2 spaces 
                                        .replace(/(\d)\s+(?=\d)/g, '$1') //to remove spacing between numbers that have >=2 digits
                                        .replace(/(\d)\s+%/g, '$1%') //to remove spacing between % and numbers
                                        .replace(/(Fat|Protein|Carbohydrates|Calories)\s*:\s*/gi, '$1: ')
                                        .split('\n')
                                        .map(line=>line.trim())
                                        .filter(line=>line.length > 0)
                                        .join('\n')

        if(!result || !normalizedResult){
            return{
                success:false,
                message:"Failed to extract text from image",
                data:""
            }
        }

        return {
            success:true,
            message:"Successfully extracted result from image",
            data:normalizedResult
        }
    }
    catch (err){
        return{
            success:false,
            message:err.message,
            data:"",
        }
    }
}