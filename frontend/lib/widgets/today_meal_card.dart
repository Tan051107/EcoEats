import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class TodayMealCard extends StatelessWidget {
  const TodayMealCard({super.key});

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
                      "Oatmeal with Berries",
                      style: TextStyle(
                        fontSize: subtitleText.fontSize,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "8:30 AM",
                      style:subtitleText
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "320",
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