import { doc, updateDoc, serverTimestamp } from "firebase/firestore";
import { db } from "./firebase";

export const updateUserProfile = async (uid, updatedData) => {
  try {
    const userRef = doc(db, "users", uid);

    await setDoc(doc(db, "users", uid), {
            name: updatedData.name || "",
            email: updatedData.email || "",
            age: Number(updatedData.age) || 0,
            gender: updatedData.gender || "",
            height: Number(updatedData.height) || 0,
            weight: Number(updatedData.weight) || 0,
            activity_level: updatedData.activity_level || "",
            bmr: Number(updatedData.bmr) || 0,
            diet_type: updatedData.diet_type || "",
            allergies: updatedData.allergies || [],
            goal: updatedData.goal || "",
            fcm_token: updatedData.fcm_token || "",
            created_at: serverTimestamp(),
            updated_at: serverTimestamp()
        });
    
    console.log("User profile updated successfully");
  } catch (error) {
    console.error("Error updating user profile:", error);
  }
};
