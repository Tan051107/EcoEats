import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class MealRatingAndComment extends StatelessWidget {
  const MealRatingAndComment(
    {
      super.key,
      required this.rating,
      required this.recommendation
    }
  );

  final String rating;
  final String recommendation;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double materialFontSize = screenWidth * 0.045;
    double recommendationFontSize = screenWidth * 0.035;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child:Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: lightGreen
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rating: $rating",
                style: TextStyle(
                  fontSize: materialFontSize,
                  color: gray,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                recommendation,
                style: TextStyle(
                  fontSize: recommendationFontSize,
                  overflow: TextOverflow.ellipsis,
                  color:normalGreen
                ),
                maxLines: 3,
              ),             
            ],
          ),
        ),
      )
    );
  }
}