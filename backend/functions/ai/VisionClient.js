import vision from "@google-cloud/vision";

const visionClient = new vision.ImageAnnotatorClient({
    keyFilename:'./ai/visionClientServiceAccountKey.json'
}

);


export default visionClient;