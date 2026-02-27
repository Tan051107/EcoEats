// lib/services/api_service.dart

import 'dart:convert';
import 'firebase_functions.dart';
import '../data/models/recipe_model.dart';
import '../data/models/daily_meals.dart';

class ApiService {
  static Future<Meals> getRecommendedMeals() async {
    try {
      final jsonData = {
        "date": "2026-01-01",
        "meals": {
          "breakfast": {
            "recipeId": "ABC123",
            "name": "Spicy Tomato Pasta",
            "ingredients": [
              {"name": "tomato", "quantity": "2 pieces"},
              {"name": "pasta", "quantity": "100g"}
            ],
            "steps": [
              "Boil pasta",
              "Cook tomato sauce",
              "Mix and serve"
            ],
            "nutrition": {
              "calories_kcal": 480,
              "protein_g": 16,
              "carbs_g": 65,
              "fat_g": 14
            },
            "diet_type": "vegetarian",
            "chef_name": "Madhur Jaffrey",
            "allergens": ["gluten"],
            "meal_type": "dinner",
            "created_at": "2026-01-01T00:00:00Z"
          },
          "lunch": {
            "recipeId": "ABC124",
            "name": "Spicy Tomato Pasta",
            "ingredients": [
              {"name": "tomato", "quantity": "2 pieces"},
              {"name": "pasta", "quantity": "100g"}
            ],
            "steps": [
              "Boil pasta",
              "Cook tomato sauce",
              "Mix and serve"
            ],
            "nutrition": {
              "calories_kcal": 480,
              "protein_g": 16,
              "carbs_g": 65,
              "fat_g": 14
            },
            "diet_type": "vegetarian",
            "chef_name": "Madhur Jaffrey",
            "allergens": ["gluten"],
            "meal_type": "lunch",
            "created_at": "2026-01-01T00:00:00Z"
          },
          "dinner": {
            "recipeId": "ABC125",
            "name": "Spicy Tomato Pasta",
            "ingredients": [
              {"name": "tomato", "quantity": "2 pieces"},
              {"name": "pasta", "quantity": "100g"}
            ],
            "steps": [
              "Boil pasta",
              "Cook tomato sauce",
              "Mix and serve"
            ],
            "nutrition": {
              "calories_kcal": 480,
              "protein_g": 16,
              "carbs_g": 65,
              "fat_g": 14
            },
            "diet_type": "vegetarian",
            "chef_name": "Madhur Jaffrey",
            "allergens": ["gluten"],
            "meal_type": "dinner",
            "created_at": "2026-01-01T00:00:00Z"
          }
        },
        "total_carbs_g": "117",
        "total_fat_g": "117",
        "total_protein_g": "117",
        "total_calories_kcal": "1410",
        "missing_ingredients": [
          {
            "missing_ingredients": [],
            "recipe": "Fruit Yogurt Bowl"
          },
          {
            "missing_ingredients": [],
            "recipe": "Fruit Yogurt Bowl"
          },
          {
            "missing_ingredients": [
              {
                "name": "Lemon",
                "quantity": 12
              }
            ],
            "recipe": "Fruit Yogurt Bowl"
          }
        ]
      };
      
      final mealsData = RecommendedMealsData.fromJson(jsonData);
      return mealsData.meals;
      
    } catch (e) {
      print('Error in getRecommendedMeals: $e');
      rethrow;
    }
  }

  static Future<Recipe> getRecipe(String recipeId) async {
    try {
      final Map<String, dynamic> recipeJson = {
        "recipeId": recipeId,
        "name": "Spicy Tomato Pasta",
        "ingredients": [
          {"name": "tomato", "quantity": "2 pieces"},
          {"name": "pasta", "quantity": "100g"}
        ],
        "steps": [
          "Boil pasta",
          "Cook tomato sauce",
          "Mix and serve"
        ],
        "nutrition": {
          "calories_kcal": 480,
          "protein_g": 16,
          "carbs_g": 65,
          "fat_g": 14
        },
        "diet_type": "vegetarian",
        "chef_name": "Madhur Jaffrey",
        "allergens": ["gluten"],
        "meal_type": "dinner",
        "created_at": "2026-01-01T00:00:00Z"
      };
      
      return Recipe.fromJson(recipeJson);
      
    } catch (e) {
      print('Error in getRecipe: $e');
      rethrow;
    }
  }
}