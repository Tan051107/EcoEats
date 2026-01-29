import { getPackagedNutritionLabelFromImage } from "./GetPackagedNutritionalLabelFromImage.js"
import { organizePackagedNutritionalLabelFromImage } from "./OrganizePackagedNutritionalLabelFromImage.js"

export async function getPackagedNutritionalLabelFromImageResult(image){
    try{
        const imageNutritionalLabel = await getPackagedNutritionLabelFromImage(image)

        if(!imageNutritionalLabel.data){
            return {
                success:false,
                message:imageNutritionalLabel.message,
                data:imageNutritionalLabel.data
            }
        }

        const organizedPackagedNutritionalLabelFromImage = await organizePackagedNutritionalLabelFromImage(imageNutritionalLabel.data)

        if(!organizedPackagedNutritionalLabelFromImage.success){
            return{
                success:false,
                message:organizedPackagedNutritionalLabelFromImage.message,
                data:organizedPackagedNutritionalLabelFromImage.data
            }
        }

        return{
            success:true,
            message:organizedPackagedNutritionalLabelFromImage.message,
            data:organizedPackagedNutritionalLabelFromImage.data
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