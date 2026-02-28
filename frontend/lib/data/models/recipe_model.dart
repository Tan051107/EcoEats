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

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['recipeId']?.toString() ?? json['recipe_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      ingredients: (json['ingredients'] as List?)
              ?.map((item) => Ingredient.fromJson(
                  Map<String, dynamic>.from(item as Map)))
              .toList() ??
          [],
      steps: List<String>.from(json['steps'] ?? []),
      nutrition: Nutrition.fromJson(
          Map<String, dynamic>.from(json['nutrition'] ?? {})),
      dietType: json['diet_type']?.toString() ?? '',
      chefName: json['chef_name']?.toString() ?? '',
      allergens: List<String>.from(json['allergens'] ?? []),
      mealType: json['meal_type']?.toString() ?? '',
      createdAt: DateTime.parse(
          json['created_at'] is String ? json['created_at'] : DateTime.now().toIso8601String()),
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
      name: json['name']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
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
      calories: int.tryParse(json['calories_kcal']?.toString() ?? '0') ?? 0,
      protein: (json['protein_g'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat_g'] as num?)?.toDouble() ?? 0.0,
    );
  }
}