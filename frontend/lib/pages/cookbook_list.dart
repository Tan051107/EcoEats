import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/recipe_overview_card.dart';

class CookbookList extends StatefulWidget {
  const CookbookList({super.key});

  @override
  State<CookbookList> createState() => _CookbookListState();
}

class _CookbookListState extends State<CookbookList> {
  List<Map<String,dynamic>> recipes = [];
  bool isLoading = true;

  Future<void>getRecipes()async{
    final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
    final getRecipes = functions.httpsCallable('getRecipes');
    try{
      final response = await getRecipes.call({
      });
      final List<dynamic> dataList = response.data['data'];
      final List<Map<String,dynamic>> recipeData = dataList.map((recipe)=>Map<String,dynamic>.from(recipe)).toList();
      setState(() {
        recipes = recipeData;
        isLoading = false;
      });
      print(recipeData);
      print("Total Recipes: ${recipeData.length}");
    }
    on FirebaseFunctionsException catch (e){
      print('Firebase error: ${e.code} - ${e.message}');
    }
    catch(err){
      print('Unknown error: $err');
    }
  }

  @override
  void initState() {
    getRecipes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Header(subtitle: "${recipes.length} recipes",title: "Vegan",icon: Icons.eco, iconColor: Colors.green,),
          Expanded(
            child:isLoading
                  ?Center(
                    child: Column(
                      children: [
                        Text("Loading Recipes"),
                        SizedBox(height: 5.0,),
                        CircularProgressIndicator(),
                      ], 
                    ),
                  )
                  :recipes.isEmpty
                  ?Center(
                    child: Text("No recipes found"),
                  )
                  :RefreshIndicator(
                    onRefresh: getRecipes, 
                    child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: recipes.length,
                    itemBuilder: (context,index){
                      final meal = recipes[index];
                      return RecipeOverviewCard(
                        mealName: meal['name'] ?? "Meal name", 
                        mealType: meal["meal_type"] ?? "Meal Type", 
                        mealCalories: meal["nutrition"]["calories_kcal"] ?? "Meal Calories", 
                        mealDesc: meal["description"] ?? "Meal Description",
                        isFavourite: meal["is_favourite"] ?? false,
                      );
                    }
                  )
                ),
              )
        ],
      )
    );
  }
}