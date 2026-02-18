
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverviewNutritionCard extends StatelessWidget {
  const OverviewNutritionCard(
    {
      super.key,
      required this.nutritionName,
      required this.icon,
      required this.iconBgColor,
      required this.nutritionValue,
    }
  );

  final String nutritionName;
  final String icon;
  final Color iconBgColor;
  final int nutritionValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0 , vertical: 20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBgColor,
              ),
              child:Padding(
                padding: EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                      icon,
                      width: 35.0,
                      height: 35.0,
                    ),
              )
            ),
            SizedBox(height: 3.0),
            Text(
              nutritionName,
              style: TextStyle(
                fontSize: subtitleText.fontSize,
                color: subtitleText.color
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: nutritionValue.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25
                    )
                  ),
                  TextSpan(
                    text: " g",
                    style: TextStyle(
                      fontSize: subtitleText.fontSize,
                      color: subtitleText.color
                    )
                  )
                ]
              )
            )
          ],
        ),
      )
    );
  }
}