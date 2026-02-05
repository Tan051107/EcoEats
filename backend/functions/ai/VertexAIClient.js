import { GoogleGenAI } from '@google/genai';
/** @type {import('@google/genai').GoogleGenAI} */

// Tell the environment where your key is
process.env.GOOGLE_APPLICATION_CREDENTIALS = 'C:/Users/taniv/Desktop/EcoEats/backend/functions/ai/visionClientServiceAccountKey.json';

const ai = new GoogleGenAI({
    vertexai: true,
    project: 'project-418306aa-a8a3-47a8-aec', // Your Project ID
    location: 'global',
});

// const ai = new GoogleGenAI({
//     vertexai: true,
//     // Use the ID of the project where the Vertex AI API is enabled
//     project: 'project-418306aa-a8a3-47a8-aec', 
//     location: 'us-central1', 
// });

export default ai;