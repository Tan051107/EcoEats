import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class TodayMealCard extends StatelessWidget {
  const TodayMealCard(
    {
      super.key,
      required this.mealName,
      required this.calories,
      required this.eatenTime,
    }
  );

  final String mealName;
  final int calories;
  final String eatenTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(12),
                    color: lightGreen
                  ),
                  child:Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                        Icons.fastfood,
                        size: 40,
                      ),
                  )
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealName,
                      style: TextStyle(
                        fontSize: subtitleText.fontSize,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      eatenTime,
                      style:subtitleText
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  calories.toString(),
                  style: TextStyle(
                    fontSize: subtitleText.fontSize,
                    fontWeight: FontWeight.bold
                  ),             
                ),
                Text(
                  "kcal",
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}