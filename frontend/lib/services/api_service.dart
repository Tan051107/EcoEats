// lib/services/api_service.dart
import 'package:cloud_functions/cloud_functions.dart';
import '../data/models/recipe_model.dart';
import '../data/models/daily_meals.dart';

class ApiService {
  // Helper to recursively convert _Map<Object?, Object?> to Map<String, dynamic>
  static Map<String, dynamic> _convertToMap(dynamic source) {
    if (source is! Map) return {};
    return source.map((key, value) {
      final stringKey = key.toString();
      if (value is Map) return MapEntry(stringKey, _convertToMap(value));
      if (value is List) {
        return MapEntry(
          stringKey,
          value.map((e) => e is Map ? _convertToMap(e) : e).toList(),
        );
      }
      return MapEntry(stringKey, value);
    });
  }

  static Future<RecommendedMealsData> getRecommendedMeals() async {
    try {
      final functions = FirebaseFunctions.instanceFor(region: "us-central1");
      final getDailyRecommendedMeals = functions.httpsCallable("getDailyRecommendedMeals");
      final response = await getDailyRecommendedMeals.call({});
      
      final rawData = response.data as Map;
      final Map<String, dynamic> responseResult = _convertToMap(rawData);
      
      // The backend returns { success: bool, message: string, data: { ... } }
      final Map<String, dynamic> dailyRecommendedMeals = responseResult["data"] ?? {};
      
      return RecommendedMealsData.fromJson(dailyRecommendedMeals);
      
    } on FirebaseFunctionsException catch (err) {
      throw Exception(err.message);
    } catch (e) {
      print('Error in getRecommendedMeals: $e');
      rethrow;
    }
  }

  static Future<Recipe> getRecipe(String recipeId) async {
    try {
      final functions = FirebaseFunctions.instanceFor(region: "us-central1");
      final getRecipes = functions.httpsCallable("getRecipes");
      final response = await getRecipes.call({
        "recipe_id": recipeId
      });
      
      final rawData = response.data as Map;
      final Map<String, dynamic> responseResult = _convertToMap(rawData);
      
      final Map<String, dynamic> recipe = responseResult["data"] ?? {};
      
      return Recipe.fromJson(recipe);
      
    } on FirebaseFunctionsException catch (err) {
      throw Exception(err.message);
    } catch (e) {
      print('Error in getRecipe: $e');
      rethrow;
    }
  }
}