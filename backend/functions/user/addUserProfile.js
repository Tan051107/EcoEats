import { doc, setDoc, serverTimestamp } from "firebase/firestore";
import { db } from "./firebase";

export const addUserProfile = async (uid, userData) => {
  try {
    await setDoc(doc(db, "users", uid), {
        name: userData.name || "",
        email: userData.email || "",
        age: Number(userData.age) || 0,
        gender: userData.gender || "",
        height: Number(userData.height) || 0,
        weight: Number(userData.weight) || 0,
        activity_level: userData.activity_level || "",
        bmr: Number(userData.bmr) || 0,
        diet_type: userData.diet_type || "",
        allergies: userData.allergies || [],
        goal: userData.goal || "",
        fcm_token: userData.fcm_token || "",
        created_at: serverTimestamp(),
        updated_at: serverTimestamp()
    });

    console.log("User profile created successfully");
  } catch (error) {
    console.error("Error creating user profile:", error);
  }
};
