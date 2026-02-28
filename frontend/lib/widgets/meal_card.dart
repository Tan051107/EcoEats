import 'package:flutter/material.dart';
import '../data/models/recipe_model.dart';

class MealCard extends StatelessWidget {
  final Recipe meal;
  final String mealType;
  final VoidCallback onTap;

  const MealCard({
    Key? key,
    required this.meal,
    required this.mealType,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with meal type and diet type
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Meal type tag 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      mealType,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  // Diet type tag 
                  if (meal.dietType.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        meal.dietType,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Meal name
              Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              
              // Chef name 
              if (meal.chefName.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'by ${meal.chefName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              
              // Calories and protein info
              Row(
                children: [
                  _buildInfoChip(
                    Icons.local_fire_department,
                    '${meal.nutrition.calories} kcal',
                    Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.fitness_center,
                    '${meal.nutrition.protein}g protein',
                    Colors.blue,
                  ),
                ],
              ),
              
              // Allergens (if any)
              if (meal.allergens.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  children: meal.allergens.map((allergen) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      allergen,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red[700],
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Builds a small information chip with icon and text
  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}