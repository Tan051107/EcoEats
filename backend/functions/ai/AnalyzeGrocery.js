import {getPackagedNutritionLabel} from './GetPackagedNutritionLabel.js'
import { getExpiryDateAndPackagingMaterialsFromAI } from "./GetExpiryDataAndPackagingMaterialsFromAI.js";
import { analyzeGroceryImageWithAI } from "./AnalyzeGroceryImageWithAI.js";
import { getPackagedNutritionFromDatabase } from './GetPackagedNutritionFromDatabase.js';
import { getPackagedMaterialsResult } from "./GetPackagedMaterialsResult.js";
import * as functions from 'firebase-functions'
import Joi from 'joi'
import {storePackagedFoodNutrition } from './StorePackagedFoodNutrition.js';
import admin from '../utils/firebase-admin.cjs'

export const analyzeGroceryImage =functions.https.onCall(async(request)=>{
  const receivedData = request.data
  const schema = Joi.object({
    barcodeValue:Joi.string().invalid(null),
    images:Joi.array().items(Joi.string()).invalid(null)
  })
  try{
    const {error , value} = schema.validate(receivedData);
    if(error){
      throw new functions.https.HttpsError("invalid-argument" , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)
    }

    const {barcodeValue , images} = value

    const bucket = admin.storage().bucket();
    let imagesToUri = [];
    if(images){
      imagesToUri = images.map(image=>`gs://${bucket.name}/${image}`)
    }

    let result ={};
    if(barcodeValue){
      console.log("GETTING PACKAGED NUTRITION LABEL FROM API")
      const nutritionValue = await getPackagedNutritionLabel(barcodeValue)
      let nutritionValueFromDatabase;
      if(nutritionValue.success){
        console.log("RECEIVED NUTRITION LABEL FROM API")
        console.log(JSON.stringify(nutritionValue.data, null, 2));
        result = nutritionValue.data
      }
      else{
        console.log("GETTING PACKAGED NUTRITION LABEL FROM DATABASE")
        nutritionValueFromDatabase = await getPackagedNutritionFromDatabase(barcodeValue)
        if(nutritionValueFromDatabase.success){
          console.log("RECEIVED NUTRITION LABEL FROM DATABASE")
          result = nutritionValueFromDatabase.data
        }
      }
      if(nutritionValue.success || nutritionValueFromDatabase.success){
         console.log("GETTING EPIRTY DATA AND MATERIAL PACKAGING FROM AI")
          const expiryDateAndPackagingMaterials = await getExpiryDateAndPackagingMaterialsFromAI(images);
          result.expiry_date = expiryDateAndPackagingMaterials?.data?.expiry_date_iso || "";
          const nutritionSource = nutritionValue.success ? nutritionValue.data : nutritionValueFromDatabase.data;
          result.packaging_materials = getPackagedMaterialsResult(expiryDateAndPackagingMaterials.data.packaging_materials , nutritionSource.packaging_materials)
          await storePackagedFoodWithBarcode(barcodeValue,result)
          return{
            success:true,
            message:"Successfully retrieved data from grocery image through barcode.",
            data:{
              ...result,
              barcode: barcodeValue || "",
              image_urls: imagesToUri || []
            }
          }
      }
    }
    console.log("GETTING PACKAGED NUTRITION LABEL FROM AI")
    const analyzedGroceryImageResult = await analyzeGroceryImageWithAI(images) //Get nutritional value from vertex AI
    if(barcodeValue){
      console.log("BARCODE FOUND. STORING PACKAGED NUTRITION LABEL TO DATABASE")
      const analyzedGroceryImageResultData = analyzedGroceryImageResult.data;
      await storePackagedFoodWithBarcode(barcodeValue,analyzedGroceryImageResultData)
    }
    console.log("Gemini Result:", JSON.stringify(analyzedGroceryImageResult, null, 2))
    const analyzedGroceryImageResultData = {
      ...analyzedGroceryImageResult.data,
      barcode:barcodeValue || "",
      image_urls: imagesToUri || []
    }
    return{
      ...analyzedGroceryImageResult,
      data:analyzedGroceryImageResultData
    }
  }
  catch(err){
    throw new functions.https.HttpsError("internal" , err.message)
  } 
})


async function storePackagedFoodWithBarcode(barcode,packagedFoodData){
  
    const storePackagedFoodNutritionData={
      per:packagedFoodData?.per || "",
      name:packagedFoodData?.name || "",
      category:packagedFoodData?.category || "",
      nutrition:packagedFoodData?.nutrition || {}
    }
    await storePackagedFoodNutrition(barcode,storePackagedFoodNutritionData)
}


