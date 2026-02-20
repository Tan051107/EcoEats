import adminModule from '../utils/firebase-admin.cjs';
const admin = adminModule.default ?? adminModule; 
import * as functions from 'firebase-functions'
import Joi from 'joi';

const schema = Joi.object({
  name:Joi.string().required(),
  email:Joi.string().required().email(),
  gender:Joi.string().valid("male","female").required(),
  age:Joi.number().min(1).required(),
  height:Joi.number().min(1).required(),
  weight:Joi.number().min(1).required(),
  activity_level:Joi.string().valid("sedentary","light","moderate","active","very_active").required(),
  diet_type:Joi.string().valid("Vegetarian","Non-vegetarian","Vegan").required(),
  allergies:Joi.array().items(Joi.string()).required(),
  goal:Joi.string().valid("lose_weight","gain_weight","maintain_weight","eat_healthier")
})

export const updateUserProfile =functions.https.onCall(async(request)=>{
  const db = admin.firestore();
  
  if(!request.auth){
    throw new functions.https.HttpsError("unauthenticated" , "Please login to proceed")
  }

  const userId = request.auth.uid;

  const userDocRef = db.collection("users").doc(userId);

  const {error,value} = schema.validate(request.data)

  if(error){
    throw new functions.https.HttpsError('invalid-argument' , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)
  }

  const {gender, height , weight, age} = value

  let bmr = (10*weight) + (6.25*height) + (5*age);
  if(gender == "male"){
    bmr+=5
  }
  else{
    bmr -=161;
  }

  try {
    await userDocRef.set({
      ...value,
      bmr:bmr,
      updated_at: admin.firestore.FieldValue.serverTimestamp()
    },{merge:true})

    return {
      success:true,
      message:"User updated successfully"
    }
  } catch (error) {
    throw functions.https.HttpsError("Failed to update user" , error.message)
  }
})


