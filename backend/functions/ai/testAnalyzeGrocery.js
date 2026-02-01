import fs from "fs";
import fetch from "node-fetch";
import path from "path";

const FUNCTION_URL = "http://127.0.0.1:5001/ecoeats-4f19c/us-central1/analyzeImage";

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
