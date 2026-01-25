import { setGlobalOptions } from "firebase-functions";
import { onCall } from "firebase-functions/v2/https";
import logger from "firebase-functions/logger";
setGlobalOptions({ maxInstances: 10 });

import { initializeApp, firestore } from 'firebase-admin';
initializeApp();

const database = firestore();


