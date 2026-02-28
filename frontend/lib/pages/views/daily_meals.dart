// Main page displaying daily recommended meals

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../data/models/daily_meals.dart';
import '../../widgets/meal_card.dart';
import 'recipe_detail.dart';

class DailyMealsPage extends StatefulWidget {
  const DailyMealsPage({Key? key}) : super(key: key);

  @override
  State<DailyMealsPage> createState() => _DailyMealsPageState();
}

class _DailyMealsPageState extends State<DailyMealsPage> {
  late Future<RecommendedMealsData> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = ApiService.getRecommendedMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daily Meals'),
        foregroundColor:Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _mealsFuture = ApiService.getRecommendedMeals();
          });
        },
        child: FutureBuilder<RecommendedMealsData>(
          future: _mealsFuture,
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
                          _mealsFuture = ApiService.getRecommendedMeals();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            // Show no data message
            if (!snapshot.hasData) {
              return const Center(child: Text('No meals available today'));
            }
            
            final RecommendedMealsData mealsData = snapshot.data!;
            final meals = mealsData.meals;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Today's total nutrition summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today\'s total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Calories
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Calories',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${mealsData.totalCalories} kcal',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Protein
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Protein',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${mealsData.totalProtein.toStringAsFixed(1)}g',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Fats
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Fat',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${mealsData.totalFat.toStringAsFixed(1)}g',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Carbs
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Carbs',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${mealsData.totalCarbs.toStringAsFixed(1)}g',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),                                                      
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Missing Ingredients section
                  if (mealsData.missingIngredients.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Missing Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...mealsData.missingIngredients.where((mi) => mi.ingredients.isNotEmpty || mi.rawMissingIngredients.isNotEmpty).map((mi) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(mi.recipe.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(
                          mi.ingredients.isNotEmpty 
                            ? mi.ingredients.map((ing) => "${ing.quantity} ${ing.name}").join(", ")
                            : mi.rawMissingIngredients
                        ),
                        leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      ),
                    )),
                    const SizedBox(height: 24),
                  ],
                  
                  // Breakfast
                  MealCard(
                    meal: meals.breakfast,
                    mealType: 'Breakfast',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipeId: meals.breakfast.recipeId,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Lunch
                  MealCard(
                    meal: meals.lunch,
                    mealType: 'Lunch',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipeId: meals.lunch.recipeId,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Dinner
                  MealCard(
                    meal: meals.dinner,
                    mealType: 'Dinner',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipeId: meals.dinner.recipeId,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}