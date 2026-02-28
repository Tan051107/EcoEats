import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/services/summary_service.dart';
import 'package:frontend/widgets/average_nutrition_card.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/recommendation_card.dart';
import 'package:frontend/widgets/weekly_summary_chart.dart';

class WeeklySummary extends StatefulWidget {
  const WeeklySummary({super.key});

  @override
  State<WeeklySummary> createState() => _WeeklySummaryState();
}


class _WeeklySummaryState extends State<WeeklySummary> {

  late Future<Map<String,dynamic>> weeklySummary;

  @override
  void initState() {
    super.initState();
    weeklySummary = SummaryService.getWeeklySummary();
    weeklySummary.then((data) {
    print("Weekly Summary: $data");
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child:FutureBuilder(
                future: weeklySummary ,
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
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
                                weeklySummary = SummaryService.getWeeklySummary();
                              });
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Weekly summary not found'));
                  }

                  final weeklySummaryData =Map<String, dynamic>.from((snapshot.data as Map<String, dynamic>)["data"] as Map);
                  print("Snapshot data:$weeklySummaryData");
                  final double averageCalories = (weeklySummaryData["average_daily_calories_kcal"] as num?)?.toDouble() ?? 0.0;
                  final double averageFats = (weeklySummaryData["average_daily_fat_g"] as num?)?.toDouble() ?? 0.0;
                  final double averageCarbs = (weeklySummaryData["average_daily_carbs_g"] as num?)?.toDouble() ?? 0.0;
                  final double averageProtein = (weeklySummaryData["average_daily_protein_g"] as num?)?.toDouble() ?? 0.0;
                  final double neededDailyIntake = (weeklySummaryData["daily_calorie_intake_kcal"] as num?)?.toDouble() ?? 0.0;
                  final List<String> recommendations = (weeklySummaryData["recommendations"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
                  final List<String> neededSummaryDataKeys = ["day", "is_over_target", "total_calories_kcal"];
                  final List<Map<String, dynamic>> dailySummary =
                    (weeklySummaryData["each_day_summary"] as List<dynamic>?)
                      ?.map((e) {
                        final data = Map<String, dynamic>.from(e);
                        return {
                          for (var key in neededSummaryDataKeys)
                            if (data.containsKey(key)) key: data[key],
                        };
                      }).toList() ?? [];
                  print("Daily Summary:$dailySummary");
                  final String startDate = weeklySummaryData["start_date"] ?? "";
                  final String endDate = weeklySummaryData["end_date"] ?? "";
                  late String subtitle;
                  if(startDate.isNotEmpty&& endDate.isNotEmpty){
                    subtitle = "$startDate-$endDate";
                  }
                  else{
                    subtitle = "";
                  }
                  return Column(
                    children: [
                      SizedBox(height: 50.0),
                      Header(title: "Weekly Summary", isShowBackButton: false , subtitle: subtitle),
                      SizedBox(height: 15.0),
                      Expanded(
                        child:SingleChildScrollView(
                          child: Column(
                            children: [
                              AverageCaloriesSection(
                                averageDailyCalories: averageCalories,
                                neededDailyIntake: neededDailyIntake,
                              ),
                              SizedBox(height: 20.0),
                              DailyBreakdownSection(
                                summaryData: dailySummary,
                              ),
                              SizedBox(height: 20.0),
                              AverageNutritionSection(
                                averageCarbs: averageCarbs,
                                averageFat: averageFats,
                                averageProtein: averageProtein,
                              ),
                              if(recommendations.isNotEmpty)...[
                                SizedBox(height: 20.0,),
                                RecommendationsSection(recommendations:recommendations)
                              ]
                            ],
                          ),
                        )
                      )
                    ],
                  );
                }
              )
            )
);
  }
}

class AverageCaloriesSection extends StatelessWidget {
  const AverageCaloriesSection(
    {
      super.key,
      required this.averageDailyCalories,
      required this.neededDailyIntake
    }
  );

  final double averageDailyCalories;
  final double neededDailyIntake;

  @override
  Widget build(BuildContext context) {
    final double calorieIntakePercentage = averageDailyCalories/neededDailyIntake;
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)
        ),
        child:Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Average Daily Calories",
                style: subtitleText,
              ),
              SizedBox(height: 10.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: averageDailyCalories.toString(),
                      style: headerText.copyWith(
                        color: calorieIntakePercentage > 1 ? normalRed : Colors.black
                      )
                    ),
                    TextSpan(
                      text: "/${neededDailyIntake.toString()}",
                      style: subtitleText
                    )
                  ]
                )
              ),
              SizedBox(height: 10.0),
              SizedBox(
                height: 10.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: LinearProgressIndicator(
                    value: calorieIntakePercentage,
                    color: calorieIntakePercentage > 1 ? normalRed : normalGreen,
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

class DailyBreakdownSection extends StatelessWidget {
  const DailyBreakdownSection(
    {
      super.key,
      required this.summaryData
    }
  );
  final List<Map<String,dynamic>> summaryData;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Breakdown",
              style: headingThreeText,
            ),
            WeeklySummaryChart(summaryData: summaryData)
          ],
        ),
      ),
    );
  }
}


class AverageNutritionSection extends StatelessWidget {
  const AverageNutritionSection(
    {
      super.key,
      required this.averageProtein,
      required this.averageFat,
      required this.averageCarbs,
    }
  );
    
  final double averageProtein;
  final double averageFat;
  final double averageCarbs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: screenWidth,
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: AverageNutritionCard(name:"Avg Protein" , value:averageProtein  , circleColor: normalYellow , unit: "g",)
          ),
          Expanded(
            child: AverageNutritionCard(name:"Avg Carbs" , value: averageCarbs , circleColor: orange,unit: "g"),
          ),
          Expanded(
            child:AverageNutritionCard(name:"Avg Fats" , value: averageFat, circleColor: normalBlue,unit: "g")
          )
        ],
      ),
    )
    );
  }
}

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection(
    {
      super.key,
      required this.recommendations
    }
  );

  final List<String> recommendations;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: normalGreen,
              size: 30.0,
            ),
            Text(
              "Recommendations",
              style: headingThreeText,
            )
          ],
        ),
        ...List.generate(
          recommendations.length,
          (index){
            final String recommendation = recommendations[index];
            return RecommendationCard(recommendation: recommendation);
          }
        )
      ],
    );
  }
}