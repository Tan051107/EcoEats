


import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class QuickAccessButtons extends StatelessWidget {
  const QuickAccessButtons(
    {
      super.key,
      required this.name,
      required this.icon,
      required this.bgColor,
      required this.fontColor,
      required this.onTap
    }
  );

  final String name;
  final IconData icon;
  final Color bgColor;
  final Color fontColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 8.0,
        color:bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child:Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 30.0,
                color: fontColor,
              ),
              SizedBox(height: 3.0),
              Text(
                name,
                style: TextStyle(
                  fontSize: subtitleText.fontSize,
                  fontWeight: FontWeight.bold,
                  color: fontColor
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}