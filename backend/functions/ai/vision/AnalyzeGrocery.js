import admin from '../../utils/firebase-admin.js'
import { visionAnalyze } from './VisionAnalyze.js';
import { groceryKeyMapping } from './GroceryKeyMapping.js';

const database = admin.firestore();

import fs from 'fs'

const imageBuffer = fs.readFileSync('../test-image/apple.jpg');
const base64Image = imageBuffer.toString('base64');

async function analyzeGroceryImage(image){ //image in URI
    const [freshSnapshot , packagedSnapshot] = await Promise.all([
        database.collection('grocery_keys').doc('fresh').get(),
        database.collection('grocery_keys').doc('packaged').get
    ]);

    const freshKeys = freshSnapshot.data();
    const packagedKeys = packagedSnapshot.data();

    const visionAnalyzeResult = await visionAnalyze(image)

    const visionLabels = [
        ...visionAnalyzeResult.labels.map(label=>label.label),
        ...visionAnalyzeResult.logos.map(logo=>logo.label),
        ...visionAnalyzeResult.objects.map(object=>object.name)
    ]

    const result = groceryKeyMapping(visionAnalyzeResult,packagedKeys,freshKeys)
    if(result.found){
        console.log(result)
    }
    else{
        console.log(visionLabels)
    }
}

analyzeGroceryImage(base64Image);