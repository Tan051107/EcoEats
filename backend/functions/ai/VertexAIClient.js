import { GoogleGenAI } from '@google/genai';
/** @type {import('@google/genai').GoogleGenAI} */


const ai = new GoogleGenAI({
    vertexai: true,
    project: 'ecoeats-4f19c',
    location: 'us-central1',
});


export default ai;