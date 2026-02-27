import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../data/models/recipe_model.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  const RecipeDetailPage({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Future<Recipe> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = ApiService.getRecipe(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Recipe>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          // Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Show error message
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _recipeFuture = ApiService.getRecipe(widget.recipeId);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          // Show not found message
          if (!snapshot.hasData) {
            return const Center(child: Text('Recipe not found'));
          }
          
          final recipe = snapshot.data!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe name
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Chef name (if available)
                if (recipe.chefName.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'by ${recipe.chefName}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                
                // Diet type and allergens
                Wrap(
                  spacing: 8,
                  children: [
                    // Diet type tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recipe.dietType,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // Allergen tags
                    ...recipe.allergens.map((allergen) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        allergen,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                        ),
                      ),
                    )),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Nutrition Facts section
                const Text(
                  'Nutrition Facts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildNutritionRow('Calories', '${recipe.nutrition.calories} kcal', Colors.green),
                      const Divider(),
                      _buildNutritionRow('Protein', '${recipe.nutrition.protein}g', Colors.blue),
                      const Divider(),
                      _buildNutritionRow('Carbs', '${recipe.nutrition.carbs}g', Colors.orange),
                      const Divider(),
                      _buildNutritionRow('Fats', '${recipe.nutrition.fat}g', Colors.red),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Ingredients section
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...recipe.formattedIngredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ingredient,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 24),
                
                // Steps section (if available)
                if (recipe.steps.isNotEmpty) ...[
                  const Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recipe.steps.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step number circle
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Step description
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Builds a row for nutrition facts display
  Widget _buildNutritionRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}