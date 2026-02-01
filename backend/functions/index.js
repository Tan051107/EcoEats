import { onRequest } from "firebase-functions/v2/https";
import { analyzeGroceryImage } from "./ai/AnalyzeGrocery.js";
import { getEstimatedMealNutrition } from "./ai/getEstimatedMealNutrition.js";

// Note: Use 'export' with the v2 onRequest trigger
export const analyzeImage = onRequest(async (req, res) => {
  try {
    // 1. Check if body exists (Emulator safety)
    if (!req.body || !req.body.image) {
      return res.status(400).json({ error: "image field is missing in request body" });
    }

    const {image} = req.body;

    // 2. Call your logic
    const result = await getEstimatedMealNutrition(image);
    
    // 3. Return successful JSON
    return res.status(200).json(result); 

  } catch (err) {
    // This will now show up in your emulator console properly
    console.error("Function error:", err); 
    
    // Always return JSON, even on error, to prevent that "Unexpected token I" error
    return res.status(500).json({ 
      error: "Internal Server Error", 
      details: err.message 
    });
  }
});