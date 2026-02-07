import {getPackagedNutritionLabel} from './GetPackagedNutritionLabel.js'
import { getExpiryDateAndPackagingMaterialsFromAI } from "./GetExpiryDataAndPackagingMaterialsFromAI.js";
import { analyzeGroceryImageWithAI } from "./AnalyzeGroceryImageWithAI.js";
import { getPackagedNutritionFromDatabase } from './GetPackagedNutritionFromDatabase.js';
import { getPackagedMaterialsResult } from "./GetPackagedMaterialsResult.js";
import * as functions from 'firebase-functions'
import Joi from 'joi'
import {storePackagedFoodNutrition } from './StorePackagedFoodNutrition.js';

export const analyzeGroceryImage =functions.https.onCall(async(request)=>{
  const receivedData = request.data
  // const schema = Joi.object({
  //   barcodeValue:Joi.string().invalid("" , null),
  //   images:Joi.array().items(Joi.string().uri()).invalid(null)
  // })
  try{
  //   const {error , value} = schema.validate(receivedData);
  //   if(error){
  //     throw new functions.https.HttpsError("invalid-argument" , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)
  //   }

    const {barcodeValue ,image1,image2} = receivedData

    let result ={};
    if(barcodeValue !== undefined){
      const nutritionValue = await getPackagedNutritionLabel(barcodeValue)
      let nutritionValueFromDatabase;
      if(nutritionValue.success){
        console.log(JSON.stringify(nutritionValue.data, null, 2));
        result = nutritionValue.data
      }
      else{
        nutritionValueFromDatabase = await getPackagedNutritionFromDatabase(barcodeValue)
        if(nutritionValueFromDatabase.success){
          result = nutritionValueFromDatabase.data
        }
      }
      if(nutritionValue.success || nutritionValueFromDatabase.success){
          const expiryDateAndPackagingMaterials = await getExpiryDateAndPackagingMaterialsFromAI(image1 , image2);
          result.expiry_date = expiryDateAndPackagingMaterials?.data?.expiry_date_iso || "";
          result.packaging_materials = getPackagedMaterialsResult(expiryDateAndPackagingMaterials.data.packaging_materials , nutritionValue.data.packaging_materials)
          return{
            success:true,
            message:"Successfully retrived data from grocery image through barcode.",
            data:result
          }
      }
    }
    const analyzedGroceryImageResult = await analyzeGroceryImageWithAI(image1 , image2) //Get nutritional value from vertex AI
    if(barcodeValue !== undefined){
      await storePackagedFoodNutrition(barcodeValue,analyzedGroceryImageResult)
    }
    console.log("Gemini Result:", JSON.stringify(analyzedGroceryImageResult, null, 2))
    return analyzedGroceryImageResult
  }
  catch(err){
    throw new functions.https.HttpsError("internal" , err.message)
  } 
})

