
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class IconSubtitle extends StatelessWidget {
  const IconSubtitle(
    {
      super.key,
      required this.icon,
      required this.name,
      required this.iconColor,
      required this.activeCard,
    }
  );

  final IconData icon;
  final String name;
  final Color iconColor;
  final String activeCard;

  @override
  Widget build(BuildContext context) {
    bool isActive = name == activeCard;
    return Container(
        width: 125.0,
        height: 110.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: lightGreen,
          border: Border.all(
            color: isActive ? normalGreen : Colors.transparent,
            width: 2.0
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30.0,
                color: iconColor,
              ),
              SizedBox(height: 5.0),
              Text(
                name,
                style: smallText,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
  }
}