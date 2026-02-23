class ManualAddGroceryFormData {
  final String groceryName;
  final String category;
  final String quantity;
  final int estimatedShelfLife;
  final int calories;
  final int carbs;
  final int protein; 
  final int fat;

  ManualAddGroceryFormData({
    required this.calories,
    required this.carbs,
    required this.category,
    required this.estimatedShelfLife,
    required this.fat,
    required this.groceryName,
    required this.protein,
    required this.quantity
  });
}