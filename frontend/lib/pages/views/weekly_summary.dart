import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Header(title: "Weekly Summary", isShowBackButton: false , subtitle: "Jan 13 - Jan 19, 2026"),
            SizedBox(height: 15.0),
            Expanded(
              child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AverageCaloriesSection(),
                            SizedBox(height: 20.0),
                            DailyBreakdownSection(),
                            SizedBox(height: 20.0),
                            AverageNutritionSection(),
                            SizedBox(height: 20.0,),
                            RecommendationsSection()
                          ],
                        ),
                      )
            )
          ],
        ),
      ),
    );
  }
}

class AverageCaloriesSection extends StatelessWidget {
  const AverageCaloriesSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                      text: "1850",
                      style: headerText
                    ),
                    TextSpan(
                      text: "/2000 kcal",
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
                    value: 0.6,
                    color: normalGreen,
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
  const DailyBreakdownSection({super.key});

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
            WeeklySummaryChart()
          ],
        ),
      ),
    );
  }
}


class AverageNutritionSection extends StatelessWidget {
  const AverageNutritionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AverageNutritionCard(name:"Protein" , value: 96 , circleColor: normalYellow),
        AverageNutritionCard(name:"Carbs" , value: 96 , circleColor: orange,),
        AverageNutritionCard(name:"Fats" , value: 96, circleColor: normalBlue,)
      ],
    );
  }
}

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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
        RecommendationCard(recommendation: "Increase protein intake by 15g to reach your goal"),
        RecommendationCard(recommendation: "Increase protein intake by 15g to reach your goal"),
        RecommendationCard(recommendation: "Increase protein intake by 15g to reach your goal")
      ],
    );
  }
}