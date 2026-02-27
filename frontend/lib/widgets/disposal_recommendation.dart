import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class DisposalRecommendation extends StatelessWidget {
  const DisposalRecommendation(
    {
      super.key,
      required this.material,
      required this.disposalWay
    }
  );

  final String material;
  final String disposalWay;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double materialFontSize = screenWidth * 0.045;
    double disposalWayFontSize = screenWidth * 0.04;
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
                material,
                style: TextStyle(
                  fontSize: materialFontSize,
                  color: gray,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                disposalWay,
                style: TextStyle(
                  fontSize: disposalWayFontSize,
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