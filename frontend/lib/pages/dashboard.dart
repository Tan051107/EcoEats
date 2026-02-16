import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/overview_nutrition_card.dart';
import 'package:frontend/widgets/quick_access_buttons.dart';
import 'package:frontend/widgets/recipe_type_card.dart';
import 'package:frontend/widgets/today_meal_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {

  List<Map<String,dynamic>> quickAccessButtons = [
    {
      "name":"Daily Meals",
      "icon": Icons.fastfood_outlined,
      "color":normalGreen,
      "bgColor":lightGreen
    },
    {
      "name":"Favourites",
      "icon": Icons.favorite_border_sharp,
      "color":normalGreen,
      "bgColor":lightGreen
    },
    {
      "name":"Scan Food",
      "icon":Icons.camera_alt_outlined,
      "color":Colors.white,
      "bgColor":normalGreen,
    },
    {
      "name":"Add Grocery",
      "icon":Icons.local_grocery_store_outlined,
      "color":Colors.white,
      "bgColor":orange
    }
  ];

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child:Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Header(title: "Dashboard" , subtitle: getGreetings(), isShowBackButton: false),
                        Padding(
                          padding:EdgeInsets.only(top:50.0 , left:16.0),
                          child:Container(
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
                        )],
                    ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child:SingleChildScrollView(
                      child:Column(
                        children: [
                          NutritionOverview(),
                          GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: 1.8,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              children: List.generate(
                                quickAccessButtons.length, (index){
                                  final button = quickAccessButtons[index];
                                  return QuickAccessButtons(name: button["name"], icon: button["icon"] , fontColor: button["color"], bgColor: button["bgColor"]);
                                }),
                            ),
                          TodayMealSection(),
                          SizedBox(height: 20.0),
                          CookBookSection()
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

class NutritionOverview extends StatelessWidget {
  const NutritionOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8.0),
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
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: orange,
                                shape: BoxShape.circle
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Today's Calories",
                                  style: TextStyle(
                                    fontSize: subtitleText.fontSize,
                                    color: subtitleText.color
                                  ),
                                ),
                                Row(
                                  textBaseline: TextBaseline.alphabetic,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      "1200",
                                      style: TextStyle(
                                        fontSize: headerText.fontSize,
                                        fontWeight: headerText.fontWeight
                                      ),
                                    ),
                                    SizedBox(width: 3.0),
                                    Text(
                                      "/2000 kcal",
                                      style: TextStyle(
                                        fontSize: subtitleText.fontSize,
                                        color: subtitleText.color
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],     
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Remaining",
                              style: TextStyle(
                                fontSize: subtitleText.fontSize,
                                color: subtitleText.color
                              ),
                            ),
                            Text(
                              "1230",
                              style: TextStyle(
                                color: normalGreen,
                                fontSize:20.0,
                                fontWeight: FontWeight.w600
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 5.0),
                    SizedBox(
                      height: 10.0,
                      child:ClipRRect(
                        borderRadius:BorderRadiusGeometry.circular(12.0),
                        child: LinearProgressIndicator(
                                value: 0.6,
                                color: normalGreen
                              ),
                      )
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                OverviewNutritionCard(),
                OverviewNutritionCard(),
                OverviewNutritionCard()
              ],
            ),
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

class TodayMealSection extends StatelessWidget {
  const TodayMealSection({super.key});

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
        TodayMealCard(),
        TodayMealCard(),
        TodayMealCard()
      ],
    );
  }
}