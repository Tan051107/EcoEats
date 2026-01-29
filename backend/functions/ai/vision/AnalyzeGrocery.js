import admin from "../../utils/firebase-admin.cjs";
import {visionAnalyze} from "./VisionAnalyze.js";
import {groceryKeyMapping} from "./GroceryKeyMapping.js";
import { getPackagedNutritionLabel } from "./getPackagedNutritionLabel.js";
import { getExpiryDateFromAI } from "./GetExpiryDataFromAI.js";
import { getPackagedNutritionalLabelFromImageResult } from "./GetPackagedNutritionalLabelFromImageResult.js";
import { analyzeGroceryImageWithAI } from "./AnalyzeGroceryImageWithAI.js";

const database = admin.firestore();


export async function analyzeGroceryImage(image , barcodeValue) {
  try{
      const result ={};
      let returnNutritionLabelAndPackaging = {};
      if(barcodeValue){
        const [nutritionValue , expiryDate] = await Promise.all([
          getPackagedNutritionLabel(barcodeValue), //Get nutritional value from open food facts API
          getExpiryDateFromAI(image) //Get expiry date through vertex AI Gemini
        ])

        if(nutritionValue.success){
          if(nutritionValue.data.packaging.length < 1){
            console.log("Packaging not found. Calling vertex ai to detect packaging")
          }
          returnNutritionLabelAndPackaging = nutritionValue.data
          console.log(JSON.stringify(nutritionValue.data, null, 2));
        }
        else{
          console.log("Barcode value found but not able to find nutrition value. Calling vertex ai")
          console.log(nutritionValue.message)
          const packagedNutritionalLabelFromImageResult = await getPackagedNutritionalLabelFromImageResult(image);
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
        const analyzedGroceryImageResult = await analyzeGroceryImageWithAI(image)
        if(!analyzedGroceryImageResult){
            return{
              success:false,
              message:err.message,
              data:{}
            }
        }

        result ={
          name:analyzedGroceryImageResult?.name || "",
          per:analyzedGroceryImageResult?.per ||"",
          calories:analyzedGroceryImageResult?.calories || "",
          fat_g:analyzedGroceryImageResult?.fat_g || "",
          carbohydrates_g:analyzedGroceryImageResult?.carbohydrates_g || "",
          protein_g:analyzedGroceryImageResult?.protein_g || "",
          packaging:analyzedGroceryImageResult?.packaging || [],
          category:analyzedGroceryImageResult?.category || "",
          expiry_date:analyzedGroceryImageResult?.expiry_date || "",
          estimated_shelf_life:analyzedGroceryImageResult?.estimated_shelf_life || "",
          is_packaged:true
        }
      }

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

  // const freshKeys = freshSnapshot.data();
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