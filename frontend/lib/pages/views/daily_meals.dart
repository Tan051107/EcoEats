// Main page displaying daily recommended meals

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late Future<Meals> _mealsFuture;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _mealsFuture = ApiService.getRecommendedMeals();
  }

  // Signs out the current user and navigates to login page
  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daily Meals'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _mealsFuture = ApiService.getRecommendedMeals();
          });
        },
        child: FutureBuilder<Meals>(
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
            
            final meals = snapshot.data!;
            
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
                                    '${meals.totalCalories} kcal',
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
                                    '${meals.totalProtein.toStringAsFixed(1)}g',
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
                  
                  const SizedBox(height: 20),
                  
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