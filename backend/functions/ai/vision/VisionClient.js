import vision from '@google-cloud/vision';

const CLIENT_VISION_ID = "project-418306aa-a8a3-47a8-aec";

const visionClient = new vision.ImageAnnotatorClient({
    projectId: CLIENT_VISION_ID,
});


export default visionClient;