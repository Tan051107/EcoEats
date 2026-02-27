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

  RecommendedMealsData({
    required this.date,
    required this.meals,
  });

  // Creates a RecommendedMealsData instance from JSON
  factory RecommendedMealsData.fromJson(Map<String, dynamic> json) {
    return RecommendedMealsData(
      date: json['date'] ?? '',
      meals: Meals.fromJson(json['meals'] ?? {}),
    );
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
      breakfast: Recipe.fromJson(json['breakfast'] ?? {}),
      lunch: Recipe.fromJson(json['lunch'] ?? {}),
      dinner: Recipe.fromJson(json['dinner'] ?? {}),
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