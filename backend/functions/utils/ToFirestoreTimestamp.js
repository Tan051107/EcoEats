import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule;

export function toFirestoreTimestamp(dateStr){
    const date = new Date(`${dateStr}T00:00:00.000Z`);
    return admin.firestore.Timestamp.fromDate(date)
}