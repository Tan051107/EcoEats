import fs from "fs";
import fetch from "node-fetch";
import path from "path";

const project = process.env.ECOEATS_FIREBASE_PROJECT_ID;
if (!project) {
  throw new Error('Set ECOEATS_FIREBASE_PROJECT_ID before running this test.');
}

const host = process.env.ECOEATS_EMULATOR_HOST || '127.0.0.1:5001';
const region = process.env.ECOEATS_FUNCTIONS_REGION || 'us-central1';
const FUNCTION_URL = `http://${host}/${project}/${region}/analyzeImage`;

const IMAGE_PATH = path.resolve("./test-image/salmon-image.png");
const base64Image = fs.readFileSync(IMAGE_PATH).toString("base64");

async function testFunction() {
  try {
    const res = await fetch(FUNCTION_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(
        { image: base64Image,
        })
    });

    const data = await res.json(); // safe now
    console.log("Function response:", data);
  } catch (err) {
    console.error("Error calling function:", err);
  }
}

testFunction();
