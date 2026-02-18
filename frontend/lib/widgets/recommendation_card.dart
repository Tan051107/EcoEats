
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard(
    {
      super.key,
      required this.recommendation,
    }
  );

  final String recommendation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            recommendation,
            style: TextStyle(
              fontSize: smallText.fontSize
            ),
          )
        ),
      ),
    );
  }
}