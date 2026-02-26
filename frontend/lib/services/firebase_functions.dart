import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/daily_meals.dart';
import '../data/models/recipe_response.dart';

class FirebaseFunctionsService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _currentUserId => _auth.currentUser?.uid;

  static void _checkAuth() {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
  }

  // Fetches recommended meals for the current user
  static Future<RecommendedMealsResponse> getRecommendedMeals() async {
    try {
      _checkAuth(); // Make sure user is logged in
      
      final HttpsCallable callable = _functions.httpsCallable('getRecommendedMeals');
      final result = await callable.call();
      
      return RecommendedMealsResponse.fromJson(result.data);
    } catch (e) {
      print('Error getting recommended meals: $e');
      rethrow;
    }
  }

  // Fetches a specific recipe by ID
  static Future<RecipesResponse> getRecipe(String recipeId) async {
    try {
      _checkAuth(); // Make sure user is logged in
      
      final HttpsCallable callable = _functions.httpsCallable('getRecipes');
      final result = await callable.call({
        'recipe_id': recipeId,
      });
      
      return RecipesResponse.fromJson(result.data);
    } catch (e) {
      print('Error getting recipe: $e');
      rethrow;
    }
  }

  // Fetches all recipes with optional filters
  static Future<RecipesResponse> getAllRecipes({
    String? category,  
    String? chef,       
  }) async {
    try {
      _checkAuth(); 
      
      final Map<String, dynamic> params = {};
      
      if (category != null) {
        params['category'] = category;
      }
      if (chef != null) {
        params['chef'] = chef;
      }
      
      final HttpsCallable callable = _functions.httpsCallable('getRecipes');
      final result = await callable.call(params);
      
      return RecipesResponse.fromJson(result.data);
    } catch (e) {
      print('Error getting recipes: $e');
      rethrow;
    }
  }
}