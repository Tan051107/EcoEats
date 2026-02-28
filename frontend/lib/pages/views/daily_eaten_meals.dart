
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/providers/daily_meals_provider.dart';
import 'package:frontend/widgets/add_food_form.dart';
import 'package:frontend/widgets/form_dialog.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/meal_details.dart';
import 'package:frontend/widgets/today_meal_card.dart';
import 'package:provider/provider.dart';

class DailyEatenMeals extends StatefulWidget {
  const DailyEatenMeals(
    {
      super.key
    }
  );

  @override
  State<DailyEatenMeals> createState() => _DailyEatenMealsState();
}


class _DailyEatenMealsState extends State<DailyEatenMeals> {
  @override
  Widget build(BuildContext context) {
      DailyMealsProvider dailyMealsProvider = context.watch<DailyMealsProvider>();
      List<Map<String,dynamic>> dailyMeals = dailyMealsProvider.dailyMeals;
      int totalDailyMeals = dailyMeals.length;
    return Scaffold(
      body:Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderSection(itemCount: dailyMeals.length),
                    SizedBox(height: 20.0),
                    if(dailyMealsProvider.isLoading)...[
                        Center(
                        child: Column(
                          children: [
                            Text("Loading meals"),
                            SizedBox(height: 5.0,),
                            CircularProgressIndicator(),
                          ], 
                        ),
                      )
                    ]
                    else if(dailyMeals.isEmpty)...[
                      Center(
                        child: Text("No meals found"),
                      )        
                    ]
                    else...[
                      ...List.generate(
                        totalDailyMeals, 
                        (index){
                          final meal = dailyMeals[index];
                          final nutrition = Map<String,dynamic>.from(meal["nutrition"] ?? {} );
                          final List<String> images = (meal["image_urls"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
                          final int calories = nutrition["calories_kcal"] ?? 0;
                          final String eatenAtTime = meal["eaten_at"] ?? "";
                          return GestureDetector(
                            onTap: () async{
                            await showFormDialog(
                              context: context, 
                              child: MealDetails(mealDetails: meal)
                            );
                          },
                            child: TodayMealCard(
                              mealName: meal["name"], 
                              calories:calories, 
                              eatenTime: eatenAtTime,
                              images:images ,
                            )
                          );
                        }
                      )
                    ]
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }
}


class HeaderSection extends StatefulWidget {
  const HeaderSection(
    {
      super.key,
      required this.itemCount,
    }
  );

  final int itemCount;

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Header(title: "Today's Meal" , subtitle: "${widget.itemCount} meal${widget.itemCount>1 ? 's' : ""}", isShowBackButton: false),
        GestureDetector(
          onTap: ()async{
            await showFormDialog(
              context: context, 
              child: AddFoodForm()
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: normalGreen
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        )
      ],
    )
  );
  }
}