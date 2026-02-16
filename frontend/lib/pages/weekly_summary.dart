import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/widgets/header.dart';

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
            Header(title: "Dashboard", isShowBackButton: false , subtitle: "Jan 13 - Jan 19, 2026"),
            SizedBox(height: 10.0),
            AverageCaloriesSection()
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