import { GoogleGenAI } from '@google/genai';
/** @type {import('@google/genai').GoogleGenAI} */
import path from 'path';

// Tell the environment where your key is
process.env.GOOGLE_APPLICATION_CREDENTIALS = path.join(process.cwd(), 'ai/vision/visionClientServiceAccountKey.json');

const ai = new GoogleGenAI({
    vertexai: true,
    project: 'project-418306aa-a8a3-47a8-aec', // Your Project ID
    location: 'global',
});

export default ai;