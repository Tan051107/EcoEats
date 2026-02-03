import {getPackagedNutritionLabel} from './GetPackagedNutritionLabel.js'
import { getExpiryDateAndPackagingMaterialsFromAI } from "./GetExpiryDataAndPackagingMaterialsFromAI.js";
import { analyzeGroceryImageWithAI } from "./AnalyzeGroceryImageWithAI.js";
import { getPackagedMaterialsResult } from "./GetPackagedMaterialsResult.js";

export async function analyzeGroceryImage(images , barcodeValue) {
  try{
      let result ={};
      if(barcodeValue){
        const nutritionValue = await getPackagedNutritionLabel(barcodeValue)
        if(nutritionValue.success){
          console.log(JSON.stringify(nutritionValue.data, null, 2));
          result = nutritionValue.data
          const expiryDateAndPackagingMaterials = await getExpiryDateAndPackagingMaterialsFromAI(images);
          result.expiry_date = expiryDateAndPackagingMaterials?.data?.expiry_date_iso || "";
          result.packaging_materials = getPackagedMaterialsResult(expiryDateAndPackagingMaterials.packaging_materials , nutritionValue.data.packaging_materials)
          return{
            success:true,
            message:"Successfully retrived data from grocery image",
            data:result
          }
        }
      }
      const analyzedGroceryImageResult = await analyzeGroceryImageWithAI(images) //Get nutritional value from vertex AI
      console.log("Gemini Result:", JSON.stringify(analyzedGroceryImageResult, null, 2))
      return analyzedGroceryImageResult
    }
    catch(err){
      throw new Error("Failed to analyze grocery image" ,{cause:err})
    }
  }
