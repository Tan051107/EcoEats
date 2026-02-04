import * as functions from 'firebase-functions'
import { getAllRecipes } from './GetAllRecipesHelper.js'
import Joi from 'joi'

export const getRecipes = functions.https.onCall(async(request)=>{
    console.log("Received data:", request.data)
    try{
        const schema = Joi.object({
            category:Joi.string().valid("Vegetarian" ,"Non-vegetarian" , "Vegan").invalid(null,""),
            chef:Joi.string().invalid("" , null)
        })

        const {error , value} = schema.validate(request.data ,{ stripUnknown: true });

        if(error){
            throw new functions.https.HttpsError("invalid-argument" , `Validation failed: ${error.details.map(d => `${d.path.join(".")}: ${d.message}`).join(", ")}`)
        }

        const {category ,chef} = value;

        const allRecipes = await getAllRecipes(category,chef)
        console.log(chef)
        
        return {
            success:true,
            message:"Successfully retrieved all recipes",
            data:allRecipes.data,
            noOfDocsReturned:"No of Docs Returned:" + allRecipes.data.length,
            payLoadPassed:value
        }
    }
    catch(err){
        throw new functions.https.HttpsError('internal' , err.message)
    }
})