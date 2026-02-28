// Model classes for daily recommended meals

import 'recipe_model.dart';

// Response wrapper for getRecommendedMeals API
class RecommendedMealsResponse {
  final bool success;
  final String message;
  final RecommendedMealsData data;

  RecommendedMealsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Creates a RecommendedMealsResponse instance from JSON
  factory RecommendedMealsResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedMealsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RecommendedMealsData.fromJson(json['data'] ?? {}),
    );
  }
}

// Data container for daily meals
class RecommendedMealsData {
  final String date;
  final Meals meals;
  final double totalCarbs;
  final double totalFat;
  final double totalProtein;
  final int totalCalories;
  final List<MissingIngredient> missingIngredients;

  RecommendedMealsData({
    required this.date,
    required this.meals,
    required this.totalCarbs,
    required this.totalFat,
    required this.totalProtein,
    required this.totalCalories,
    required this.missingIngredients,
  });

  // Creates a RecommendedMealsData instance from JSON
  factory RecommendedMealsData.fromJson(Map<String, dynamic> json) {
    return RecommendedMealsData(
      date: json['date']?.toString() ?? '',
      meals: Meals.fromJson(json),
      totalCarbs: (json['total_carbs_g'] as num?)?.toDouble() ?? 0.0,
      totalFat: (json['total_fat_g'] as num?)?.toDouble() ?? 0.0,
      totalProtein: (json['total_protein_g'] as num?)?.toDouble() ?? 0.0,
      totalCalories: (json['total_calories_kcal'] as num?)?.toInt() ?? 0,
      // Handle both camelCase and snake_case for the list
      missingIngredients: ((json['missing_ingredients'] ?? json['missingIngredients']) as List?)
              ?.map((e) => MissingIngredient.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }
}

// Container for missing ingredients per meal
class MissingIngredient {
  final String recipe;
  final List<Ingredient> ingredients;
  final String rawMissingIngredients; // Store raw string if AI sends it as string

  MissingIngredient({
    required this.recipe,
    required this.ingredients,
    this.rawMissingIngredients = '',
  });

  factory MissingIngredient.fromJson(Map<String, dynamic> json) {
    // Handle both 'recipe' and 'mealType' for the header
    final recipeName = json['recipe']?.toString() ?? json['mealType']?.toString() ?? '';
    
    // Handle both 'missing_ingredients' and 'missingIngredients'
    final missingData = json['missing_ingredients'] ?? json['missingIngredients'];
    
    if (missingData is List) {
      return MissingIngredient(
        recipe: recipeName,
        ingredients: missingData
                .map((e) => Ingredient.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList(),
      );
    } else {
      // It's likely a string as per the AI schema
      return MissingIngredient(
        recipe: recipeName,
        ingredients: [],
        rawMissingIngredients: missingData?.toString() ?? '',
      );
    }
  }
}

// Container for all meals of the day
class Meals {
  final Recipe breakfast;
  final Recipe lunch;
  final Recipe dinner;

  Meals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  // Creates a Meals instance from JSON
  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      breakfast: Recipe.fromJson(Map<String, dynamic>.from(json['breakfast'] ?? {})),
      lunch: Recipe.fromJson(Map<String, dynamic>.from(json['lunch'] ?? {})),
      dinner: Recipe.fromJson(Map<String, dynamic>.from(json['dinner'] ?? {})),
    );
  }

  // Calculate total calories for all meals
  int get totalCalories {
    return breakfast.nutrition.calories +
        lunch.nutrition.calories +
        dinner.nutrition.calories;
  }

  // Calculate total protein for all meals
  double get totalProtein {
    return breakfast.nutrition.protein +
        lunch.nutrition.protein +
        dinner.nutrition.protein;
  }

  // Calculate total carbs for all meals
  double get totalCarbs {
    return breakfast.nutrition.carbs +
        lunch.nutrition.carbs +
        dinner.nutrition.carbs;
  }

  // Calculate total fat for all meals
  double get totalFat {
    return breakfast.nutrition.fat +
        lunch.nutrition.fat +
        dinner.nutrition.fat;
  }
}