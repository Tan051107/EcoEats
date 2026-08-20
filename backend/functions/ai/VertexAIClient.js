import { GoogleGenAI } from '@google/genai';
/** @type {import('@google/genai').GoogleGenAI} */

const project = process.env.ECOEATS_FIREBASE_PROJECT_ID ||
    process.env.GOOGLE_CLOUD_PROJECT ||
    process.env.GCLOUD_PROJECT;

if (!project) {
    throw new Error(
        'Set ECOEATS_FIREBASE_PROJECT_ID (or GOOGLE_CLOUD_PROJECT) before using Vertex AI.'
    );
}

const ai = new GoogleGenAI({
    vertexai: true,
    project,
    location: process.env.ECOEATS_VERTEX_AI_LOCATION || 'us-central1',
});


export default ai;
