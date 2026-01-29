import admin from "../../utils/firebase-admin.cjs";
import {visionAnalyze} from "./VisionAnalyze.js";
import {groceryKeyMapping} from "./GroceryKeyMapping.js";
import { getPackagedNutritionLabel } from "./getPackagedNutritionLabel.js";
import { getExpiryDateFromAI } from "./GetExpiryDataFromAI.js";
import { getPackagedNutritionalLabelFromImageResult } from "./GetPackagedNutritionalLabelFromImageResult.js";
import { analyzeGroceryImageWithAI } from "./AnalyzeGroceryImageWithAI.js";
import { analyzePackagingMaterialWithAI } from "./AnalyzePackagingMaterialWithAI.js";
import {packageTypeMapping} from "./PackageTypeMapping.js";
const database = admin.firestore();


export async function analyzeGroceryImage(image , barcodeValue) {
  try{
      let result ={};
      let returnNutritionLabelAndPackaging = {};
      if(barcodeValue){
        const nutritionValue = await getPackagedNutritionLabel(barcodeValue)
        if(nutritionValue.success){
          console.log(JSON.stringify(nutritionValue.data, null, 2));
          result = nutritionValue.data
          if(nutritionValue.data.packaging.length < 1){
            const packagingMaterials = await analyzePackagingMaterialWithAI(image)
            returnNutritionLabelAndPackaging.packaging = packagingMaterials
          }
          const expiryDate = await getExpiryDateFromAI(image);
          const packageMaterial =await packageTypeMapping(nutritionValue.data.packaging); //need to write function if recommended way is not found for a mterial, need to call gemini
        }


        else{
          console.log("Barcode value found but not able to find nutrition value. Calling vertex ai")
          console.log(nutritionValue.message)
          returnNutritionLabelAndPackaging
          //const packagedNutritionalLabelFromImageResult = await getPackagedNutritionalLabelFromImageResult(image); //get Nutritiona Label From VertexAI
          returnNutritionLabelAndPackaging = packagedNutritionalLabelFromImageResult.data
      }
        if(expiryDate.success){
          console.log(expiryDate.data)
        }
        else{
          console.log("Not able to find expiry date")
        }

        result ={
          name:returnNutritionLabelAndPackaging?.name || "",
          per:returnNutritionLabelAndPackaging?.per ||"",
          calories:returnNutritionLabelAndPackaging?.calories || "",
          fat_g:returnNutritionLabelAndPackaging?.fat_g || "",
          carbohydrates_g:returnNutritionLabelAndPackaging?.carbohydrates_g || "",
          protein_g:returnNutritionLabelAndPackaging?.protein_g || "",
          packaging:returnNutritionLabelAndPackaging?.packaging || [],
          category:returnNutritionLabelAndPackaging?.category || "",
          expiry_date:expiryDate.data.expiry_date_iso,
          is_packaged:true
        }
      }
      else{
        //const analyzedGroceryImageResult = await analyzeGroceryImageWithAI(image) //Get nutritional value from vertex AI
        if(!analyzedGroceryImageResult){
            return{
              success:false,
              message:err.message,
              data:{}
            }
        }

        const analyzedGroceryImageResultData = analyzedGroceryImageResult.data

        result ={
          name:analyzedGroceryImageResultData?.name || "",
          per:analyzedGroceryImageResultData?.per ||"",
          calories:analyzedGroceryImageResultData?.calories || "",
          fat_g:analyzedGroceryImageResultData?.fat_g || "",
          carbohydrates_g:analyzedGroceryImageResultData?.carbohydrates_g || "",
          protein_g:analyzedGroceryImageResultData?.protein_g || "",
          packaging:analyzedGroceryImageResultData?.packaging || [],
          category:analyzedGroceryImageResultData?.category || "",
          expiry_date:analyzedGroceryImageResultData?.expiry_date || "",
          estimated_shelf_life:analyzedGroceryImageResultData?.estimated_shelf_life || "",
          is_packaged:analyzedGroceryImageResultData?.is_packaged || "false"
        }
      }

      console.log("Gemini Result:", JSON.stringify(analyzedGroceryImageResultData, null, 2))

      return{
        success:true,
        message:"Successfully retrieved grocery image result",
        data:result
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


  // const [freshSnapshot, packagedSnapshot] = await Promise.all([
  //   database.collection("grocery_keys").doc("fresh").get(),
  //   database.collection("grocery_keys").doc("packaged").get(),
  // ]);

  // const freshKeys = freshSnapshot.data;
  // const packagedKeys = packagedSnapshot.data();

  // const visionAnalyzeResult = await visionAnalyze(image);

  // const visionLabels = [
  //   ...visionAnalyzeResult.labels.map((label)=>label.label),
  //   ...visionAnalyzeResult.logos.map((logo)=>logo.label),
  //   ...visionAnalyzeResult.objects.map((object)=>object.name),
  // ];

  // console.log("Vision Labels:" ,visionLabels)
  // console.log(visionAnalyzeResult)

  // const result = groceryKeyMapping(visionAnalyzeResult, packagedKeys, freshKeys);
  // if (result.found) {
  //   console.log(result);
  // } else {
  //   console.log(visionLabels);
  // }