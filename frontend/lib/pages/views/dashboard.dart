import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/providers/daily_meals_provider.dart';
import 'package:frontend/providers/favourite_provider.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/overview_nutrition_card.dart';
import 'package:frontend/widgets/quick_access_buttons.dart';
import 'package:frontend/widgets/recipe_type_card.dart';
import 'package:frontend/widgets/today_meal_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final DailyMealsProvider dailyMealsProvider = Provider.of<DailyMealsProvider>(context,listen:false);
      dailyMealsProvider.fetchDailyMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final FavouriteProvider favouriteProvider = context.watch<FavouriteProvider>();
    final DailyMealsProvider dailyMealsProvider = context.watch<DailyMealsProvider>();
    final int totalFavourites = favouriteProvider.favourites.length;
    final List<Map<String,dynamic>> dailyMeals = dailyMealsProvider.dailyMeals;
    final List<Map<String,dynamic>> mealsToShow = dailyMeals.length > 3 ? dailyMeals.sublist(0,3) : dailyMeals;
    final Map<String,dynamic> dailySummary = dailyMealsProvider.dailySummary;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Expanded(
              child:SingleChildScrollView(
                      child:Column(
                        children: [
                          _HeaderSection(),
                          if (dailyMealsProvider.isLoading)
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Loading Dashboard"),
                                SizedBox(height: 5.0),
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                          else...[
                            NutritionOverview(
                              dailySummaryOverview: dailySummary,
                            ),
                            QuickAccessButtonsSection(
                              totalFavourites: totalFavourites,
                            ),
                            SizedBox(height: 20.0),
                            if(dailyMeals.isNotEmpty)...[
                              TodayMealSection(dailyMeals:mealsToShow),
                            ],
                            SizedBox(height: 20.0),
                            CookBookSection()                  
                          ]
                        ],
                      ),
            ),
            )
          ],
        ),
      ),
    );
  }
}


Widget _HeaderSection(){
  String getGreetings() {
    DateTime now = DateTime.now();

    if (now.hour < 12) {
      return "Good morning";
    } else if (now.hour < 18) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  void viewProfile(){
    selectedPageNotifier.value = 5;
  }

  return Padding(
          padding: EdgeInsets.all(10.0),
          child:Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height:50.0),
                    Header(title: "Dashboard" , subtitle: getGreetings(), isShowBackButton: false),
                    Padding(
                      padding:EdgeInsets.only(top:50.0 , left:16.0),
                      child:GestureDetector(
                        onTap: () => viewProfile(),
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration:BoxDecoration(
                              color:normalGreen,
                              shape: BoxShape.circle
                            ),
                            child: Icon(
                              Icons.person,
                              size: 50.0,
                              color: Colors.white,
                            )
                          ),
                      )
                    )],
                ),
        );
}


class NutritionOverview extends StatelessWidget {
  const NutritionOverview(
    {
      super.key,
      required this.dailySummaryOverview
    }
  );

  final Map<String,dynamic> dailySummaryOverview;
  

  @override
  Widget build(BuildContext context) {
    print("Daily Summary Overview:$dailySummaryOverview");
    final double totalDailyEatenCalories = (dailySummaryOverview["total_calories_kcal"] as num?)?.toDouble() ?? 0.0 ;
    final double totalDailyIntake = (dailySummaryOverview["daily_calorie_intake"] as num?)?.toDouble() ?? 0.0;
    final double remainingCalories = (dailySummaryOverview["remaining_calories"] as num?)?.toDouble() ?? 0.0;
    final String totalEatenCaloriesString = totalDailyEatenCalories.ceil().toString();
    final String totalDailyIntakeString = totalDailyIntake.ceil().toString();
    final String remainingCaloriesString = remainingCalories.ceil().toString();
    return Column(
      children: [
        Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(13.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SIDE: Icon + Text
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: orange,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.local_fire_department_outlined,
                                color: Colors.white,
                                size: 45.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          // Text Column
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today's Calories",
                                  style: TextStyle(
                                    fontSize: subtitleText.fontSize,
                                    color: subtitleText.color,
                                  ),
                                  overflow: TextOverflow.ellipsis, // prevents overflow
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      totalEatenCaloriesString,
                                      style: TextStyle(
                                        color: totalDailyEatenCalories > totalDailyIntake ? normalRed : Colors.black,
                                        fontSize: headerText.fontSize,
                                        fontWeight: headerText.fontWeight,
                                      ),
                                    ),
                                    SizedBox(width: 3.0),
                                    Flexible(
                                      child: Text(
                                        "/$totalDailyIntakeString",
                                        style: TextStyle(
                                          fontSize: subtitleText.fontSize,
                                          color: subtitleText.color,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // RIGHT SIDE: Remaining
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Remaining",
                          style: TextStyle(
                            fontSize:15,
                            color: subtitleText.color,
                          ),
                        ),
                        Text(
                          remainingCaloriesString,
                          style: TextStyle(
                            color: normalGreen,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                // Progress Bar
                SizedBox(
                  height: 10.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: LinearProgressIndicator(
                      value: totalDailyEatenCalories / totalDailyIntake,
                      color: normalGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              OverviewNutritionCard(icon: "assets/icons/meat.svg", nutritionName: "Protein", iconBgColor: orange, nutritionValue: (dailySummaryOverview["total_protein_g"] as num?)?.toDouble() ?? 0,),
              OverviewNutritionCard(icon: "assets/icons/wheat.svg", nutritionName: "Carbs", iconBgColor:normalYellow, nutritionValue: (dailySummaryOverview["total_carbs_g"] as num?)?.toDouble() ?? 0),
              OverviewNutritionCard(icon: "assets/icons/droplet.svg", nutritionName: "Fats", iconBgColor:normalBlue, nutritionValue: (dailySummaryOverview["total_fat_g"] as num?)?.toDouble() ?? 0)
            ],
          ),
        )
      ],
    );
  }
}

class QuickAccessButtonsSection extends StatelessWidget {
  QuickAccessButtonsSection(
    {
      super.key,
      required this.totalFavourites
    }
  );

  final int totalFavourites;


  void scanFood(){
    previousPageNotifier.value = selectedPageNotifier.value;
    selectedPageNotifier.value = 2;
    isTakingFoodPictureNotifier.value = true;
  }

  void addGrocery(){
    previousPageNotifier.value = selectedPageNotifier.value;
    selectedPageNotifier.value =2;
    isTakingFoodPictureNotifier.value = false;
  }

  void viewDailyMeals(){

  }

  void viewFavourites(){
    previousPageNotifier.value = selectedPageNotifier.value;
    selectedPageNotifier.value = 6;
  }

  late final List<Map<String,dynamic>> quickAccessButtons = [
    {
      "name":"Daily Meals",
      "icon": Icons.fastfood_outlined,
      "color":normalGreen,
      "bgColor":lightGreen,
      "onTap":viewDailyMeals
    },
    {
      "name":"Favourites (${totalFavourites.toString()})",
      "icon": Icons.favorite_border_sharp,
      "color":normalGreen,
      "bgColor":lightGreen,
      "onTap":viewFavourites
    },
    {
      "name":"Scan Food",
      "icon":Icons.camera_alt_outlined,
      "color":Colors.white,
      "bgColor":normalGreen,
      "onTap":scanFood
    },
    {
      "name":"Add Grocery",
      "icon":Icons.local_grocery_store_outlined,
      "color":Colors.white,
      "bgColor":orange,
      "onTap":addGrocery
    }
  ];


  @override
  Widget build(BuildContext context) {
    return GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: List.generate(
              quickAccessButtons.length, (index){
                final button = quickAccessButtons[index];
                return QuickAccessButtons(
                  name: button["name"], 
                  icon: button["icon"] , 
                  fontColor: button["color"], 
                  bgColor: button["bgColor"],
                  onTap: button["onTap"],
                );
              }),
          );
  }
}

class TodayMealSection extends StatelessWidget {
  const TodayMealSection(
    {
      super.key,
      required this.dailyMeals
    }
  );

  final List<Map<String,dynamic>> dailyMeals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Meal",
              style: TextStyle(
                fontSize: headingTwoText.fontSize,
                fontWeight: headingTwoText.fontWeight
              ),
            ),
            Text(
              "See All  >",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: normalGreen
              ),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        ...List.generate(
          dailyMeals.length, 
          (index){
            final meal = dailyMeals[index];
            final nutrition = Map<String,dynamic>.from(meal["nutrition"] as Map);
            final createdAtTime = Map<String,dynamic>.from(meal["created_at"] as Map);
            final int calories = nutrition["calories_kcal"];
            final int nanoseconds = createdAtTime["_nanoseconds"];
            final int seconds = createdAtTime["_seconds"];
            DateTime eatenTime = DateTime.fromMicrosecondsSinceEpoch(
              (seconds * 1000) + (nanoseconds ~/ 1000000),
              isUtc: true
            );
            DateTime malaysiaTime = eatenTime.add(Duration(hours: 8));
            String formattedTime = DateFormat('hh:mm a').format(malaysiaTime);
            return TodayMealCard(
              mealName: meal["name"], 
              calories:calories, 
              eatenTime: formattedTime,
            );
          }
        )
      ],
    );
  }
}

class CookBookSection extends StatelessWidget {
  const CookBookSection({super.key});

  @override
  Widget build(BuildContext context) {

    List<Map<String,dynamic>> recipeTypes = [
      {
        "name":"Vegan",
        "icon": Icons.nature,
        "iconColor":Colors.green[800],
        "subtitle":"Fresh, vibrant meals powered entirely by plants",
        "bgColor":LinearGradient(
              colors: [
                Color(0x332BAB60), // from-primary/20
                Color(0x0D2BAB60), // to-primary/5
              ],
            )
      },
      {
        "name":"Vegetarian",
        "icon": Icons.eco,
        "iconColor":Colors.green,
        "subtitle":"Flavorful dishes with veggies, dairy, and eggs",
        "bgColor":LinearGradient(
                    colors: [
                      Color(0x333BA8F6), // from 20% opacity
                      Color(0x0D3BA8F6), // to 5% opacity
                    ],
                  )
      },
      {
        "name":"Non-vegetarian",
        "icon": Icons.food_bank,
        "iconColor":Colors.red,
        "subtitle":"Savory recipes with meat, seafood, and more",
        "bgColor":LinearGradient(
                    colors: [
                      Color(0x33FFD93B), // from 20% opacity
                      Color(0x0DFFD93B), // to 5% opacity
                    ],
                  )
      },

    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cookbooks",
          style: TextStyle(
            fontSize: headingTwoText.fontSize,
            fontWeight: headingTwoText.fontWeight
          ),
        ),
        SizedBox(height: 10.0),
        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(recipeTypes.length, (index){
            final type = recipeTypes[index];
            return RecipeTypeCard(iconColor: type["iconColor"], icon: type["icon"], name: type["name"], subtitle: type["subtitle"], bgColor: type["bgColor"]);
          }),
        )
      ],
    );
  }
}