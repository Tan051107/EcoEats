import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/pages/views/recipe_detail.dart';
import 'package:frontend/providers/favourite_provider.dart';
import 'package:provider/provider.dart';

class RecipeOverviewCard extends StatefulWidget {
  const RecipeOverviewCard(
    {
      super.key,
      required this.mealData
    }
  );

  final Map<String,dynamic> mealData;

  @override
  State<RecipeOverviewCard> createState() => _RecipeOverviewCardState();
}

class _RecipeOverviewCardState extends State<RecipeOverviewCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FavouriteProvider favouriteProvider = context.watch<FavouriteProvider>();
    IconData recipeIcon = Icons.set_meal;
    Color iconBackgroundColor =Color(0x1A1E9BD7);
    Color iconColor = Color(0xFF1E9BD7);
    String mealName = widget.mealData['name'] ?? "Meal name";
    String mealType = widget.mealData["meal_type"] ?? "Meal Type";
    int mealCalories = widget.mealData["nutrition"]["calories_kcal"] ?? "Meal Calories";
    String mealDesc = widget.mealData["description"] ?? "Meal Description";
    String recipeId = widget.mealData["recipeId"] ?? "";


    switch(mealType.toLowerCase()){
      case "breakfast":
        recipeIcon = Icons.wb_sunny_outlined;
        iconBackgroundColor = lightYellow;
        iconColor =normalYellow;
        break;
      case "lunch":
        recipeIcon = Icons.cloud_outlined;
        iconBackgroundColor = Color(0x1A2B9348);
        iconColor =Color(0xFF2B9348);
        break;
      case "dinner":
        recipeIcon = Icons.dark_mode_outlined;
        iconBackgroundColor = Color(0x1AE8613A);
        iconColor =Color(0xFFE8613A);
        break;
      default:
        recipeIcon = Icons.set_meal;
        iconBackgroundColor =Color(0x1A1E9BD7);
        iconColor = normalBlue;

    }
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(
                  recipeId: widget.mealData["recipeId"]
                ),
              ),
            );
          },
        child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: iconBackgroundColor
                      ),
                      child: Icon(
                        recipeIcon,
                        size: 35.0,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(mealDesc),
                          SizedBox(height: 4),
                          Text("${mealCalories.toString()} kcal")
                        ],
                      )
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => favouriteProvider.addToFavourite(widget.mealData),
                      child:Icon(
                        favouriteProvider.isFavourite(recipeId) ? Icons.favorite :Icons.favorite_border,
                        color: favouriteProvider.isFavourite(recipeId) ? Colors.red[400] : Colors.black,
                        size: 30.0,
                      ),
                    )
                  ],
                ),
              )
          ),
      )
    );
  }
}