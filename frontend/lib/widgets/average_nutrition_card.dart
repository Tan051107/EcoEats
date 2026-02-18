import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class AverageNutritionCard extends StatelessWidget {
  const AverageNutritionCard(
    {
      super.key,
      required this.name,
      required this.value,
      required this.circleColor
    }
  );

  final String name;
  final int value;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.max, 
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Container(
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:circleColor,
                ),
              ),
              Text(
                "${value.toString()} g",
                style: headingTwoText,
              ),
              Text(
                "Avg ${name}",
                style: subtitleText,
              )
            ],
          ),
        ),
      ),
    );
  }
}