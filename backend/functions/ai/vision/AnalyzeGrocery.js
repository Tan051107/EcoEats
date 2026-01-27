import admin from "../../utils/firebase-admin.cjs";
import {visionAnalyze} from "./VisionAnalyze.js";
import {groceryKeyMapping} from "./GroceryKeyMapping.js";
import { getPackagedNutritionLabel } from "./getPackagedNutritionLabel.js";
import { packageTypeMapping } from "./PackageTypeMapping.js";

const database = admin.firestore();


export async function analyzeGroceryImage(image , barcodeValue) { // image in URI
  const result ={};

  if(barcodeValue){
    const nutritionValue = await getPackagedNutritionLabel(barcodeValue)
    if(nutritionValue.success){
      if(nutritionValue.packagingType.length > 0){
        const materialsFound = packageTypeMapping(nutritionValue.packagingType)
      }
    }
    else{
      //call vertex gemini
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