import admin from "../../utils/firebase-admin.cjs";
import {visionAnalyze} from "./VisionAnalyze.js";
import {groceryKeyMapping} from "./GroceryKeyMapping.js";
import { getPackagedNutritionLabel } from "./getPackagedNutritionLabel.js";
import { packageTypeMapping } from "./PackageTypeMapping.js";
import { getExpiryDateFromAI } from "./GetExpiryDataFromAI.js";
import { getPackagedNutritionLabelFromImage } from "./GetPackagedNutritionalLabelFromImage.js";
import { organizePackagedNutritionalLabelFromImage } from "./OrganizePackagedNutritionalLabelFromImage.js";

const database = admin.firestore();


export async function analyzeGroceryImage(image , barcodeValue) {
  const result ={};
  if(barcodeValue){
    const nutritionValue = await getPackagedNutritionLabel(barcodeValue)
    const expiryDate = await getExpiryDateFromAI(image)
    if(nutritionValue.success){
      if(nutritionValue.data.packagingType.length > 0){
        const materialsFound = await packageTypeMapping(nutritionValue.data.packagingType)
        console.log(JSON.stringify(materialsFound.data, null, 2));
      }
      else{
        console.log("Packaging not found. Calling vertex ai")
      }
      console.log(JSON.stringify(nutritionValue.data, null, 2));
    }
    else{
      console.log("Barcode value found but not able to find nutrition value. Calling vertex ai")
      console.log(nutritionValue.message)
      const imageNutritionalLabel = await getPackagedNutritionLabelFromImage(image)
      if(imageNutritionalLabel.success){
        const imageOrganizedNutritionalLabel = await organizePackagedNutritionalLabelFromImage(imageNutritionalLabel.data)
        if(imageOrganizedNutritionalLabel.success){
          console.log(imageOrganizedNutritionalLabel.data)     
        }
      }
   }
    if(expiryDate.success){
      console.log(expiryDate.data)
    }
    else{
      console.log("Not able to find expiry date")
    }
  }
  else{
    console.log("Barcode value not found. Calling vertex ai")
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