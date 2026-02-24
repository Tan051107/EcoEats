import 'package:cloud_functions/cloud_functions.dart';

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
      throw Exception("Failed to get user's daily meals:$err");
    }
    catch(err){
      throw Exception("Failed to get user's daily meals:$err");
    }
  }

  static Future<String>addDailyMeals(Map<String,dynamic> mealData)async{
    final functions = FirebaseFunctions.instanceFor(region: "us-central1");
    final logMeal = functions.httpsCallable("logMeal");
    try{
      final response = await logMeal.call(mealData);
      final Map<String,dynamic> responseResult = response.data;
      return responseResult["message"] ?? "Added new meals";
    }
    on FirebaseFunctionsException catch (err){
      throw Exception("Failed to add user's daily meals:$err");
    }
    catch(err){
      throw Exception("Failed to add user's daily meals:$err");
    }
  }

}