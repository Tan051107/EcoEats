// Response model for getRecipes API

import 'recipe_model.dart';

// Response wrapper for getRecipes API
class RecipesResponse {
  final bool success;
  final String message;
  final List<Recipe>? data;                 // For multiple recipes
  final Recipe? dataForSpecificRecipe;      // For single recipe query

  RecipesResponse({
    required this.success,
    required this.message,
    this.data,
    this.dataForSpecificRecipe,
  });

  // Creates a RecipesResponse instance from JSON
  factory RecipesResponse.fromJson(Map<String, dynamic> json) {
    return RecipesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List).map((item) => Recipe.fromJson(item)).toList()
          : null,
      dataForSpecificRecipe: json['data_for_specific_recipe'] != null
          ? Recipe.fromJson(json['data_for_specific_recipe'])
          : null,
    );
  }
}