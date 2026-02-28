import 'package:cloud_functions/cloud_functions.dart';
import 'package:frontend/utils.dart';

class MealService{
  static Future<List<Map<String,dynamic>>> fetchDailyMeals()async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final getDailyEatenMeals = functions.httpsCallable("getDailyEatenMeals");
    try{
      final response = await getDailyEatenMeals.call({});
      final List<dynamic> responseData = response.data["data"];
      final List<Map<String,dynamic>> dailyMealsData = responseData.map((recipe)=>Map<String,dynamic>.from(recipe)).toList();
      return dailyMealsData;
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to get user's daily meals:${err.message}");
    }
    catch(err){
      throw Exception("Failed to get user's daily meals:$err");
    }
  }

  static Future<Map<String,dynamic>>addDailyMeals(Map<String,dynamic> mealData)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final logMeal = functions.httpsCallable("logMeal");
    List<String> unwantedKeys = ["nutrition" , "updated_at" , "date", "created_at", "eaten_at"];
    Map<String,dynamic>cleanedPayload = Utils.removeUnwantedKeys(mealData, unwantedKeys);
    try{
      final response = await logMeal.call(cleanedPayload);
      final Map<String,dynamic> responseResult = Map<String,dynamic>.from(response.data);
      final Map<String, dynamic> mealAdded = Map<String, dynamic>.from(responseResult['meal_added'] ?? {});
      return mealAdded;
      
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to add user's daily meals:${err.message}");
    }
    catch(err){
      throw Exception("Failed to add user's daily meals:$err");
    }
  }

  static Future<void> removeMeal(String mealId)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final removeMeal = functions.httpsCallable("removeMeal");
    try{
      await removeMeal.call({
        "meal_id":mealId
      });
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to add user's daily meals:${err.message}");
    }
    catch(err){
      throw Exception("Failed to add user's daily meals:$err");
    }
  }

  static Future<Map<String,dynamic>>sendFoodImagesForAnalysis(List<String>images)async{
    final functions = FirebaseFunctions.instanceFor(region:"us-central1");
    final getEstimatedMealNutrition = functions.httpsCallable("getEstimatedMealNutrition");
    try{
      final response = await getEstimatedMealNutrition.call(
        {
          "images":images
        }
      );
      if(response.data == null){
        throw Exception ("Empty response received");
      }

      final Map<String,dynamic> rawData = Map<String,dynamic>.from(response.data as Map);

      if(rawData["success"] !=true){
        throw Exception (rawData["message"] ?? "Grocery image analysis failed");
      }

      if (rawData["data"] == null) {
        throw Exception("No grocery analysis data returned");
      }

      final Map<String,dynamic> analyzedFoodImageResult = Map<String,dynamic>.from(rawData["data"] as Map);

      return analyzedFoodImageResult;

    }on FirebaseFunctionsException catch(err){
      throw Exception ("Failed to retrieve food image analysis:${err.message}");
    }
    catch(err){
      throw Exception ("Failed to retrive food image analysis:$err");
    }
  }

}