// Model classes for recipe data structure

class Recipe {
  final String recipeId;
  final String name;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final Nutrition nutrition;
  final String dietType;
  final String chefName;
  final List<String> allergens;
  final String mealType;
  final DateTime createdAt;

  Recipe({
    required this.recipeId,
    required this.name,
    required this.ingredients,
    required this.steps,
    required this.nutrition,
    required this.dietType,
    required this.chefName,
    required this.allergens,
    required this.mealType,
    required this.createdAt,
  });

  // Creates a Recipe instance from JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipeId'] ?? '',
      name: json['name'] ?? '',
      ingredients: (json['ingredients'] as List?)
              ?.map((item) => Ingredient.fromJson(item))
              .toList() ??
          [],
      steps: List<String>.from(json['steps'] ?? []),
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      dietType: json['diet_type'] ?? '',
      chefName: json['chef_name'] ?? '',
      allergens: List<String>.from(json['allergens'] ?? []),
      mealType: json['meal_type'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Returns formatted ingredient strings for display
  List<String> get formattedIngredients {
    return ingredients.map((ing) => "${ing.quantity} ${ing.name}").toList();
  }
}

// Represents a single ingredient with name and quantity
class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });

  // Creates an Ingredient instance from JSON data
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
}

// Represents nutritional information for a recipe
class Nutrition {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  // Creates a Nutrition instance from JSON data
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories_kcal'] ?? 0,
      protein: (json['protein_g'] ?? 0).toDouble(),
      carbs: (json['carbs_g'] ?? 0).toDouble(),
      fat: (json['fat_g'] ?? 0).toDouble(),
    );
  }
}