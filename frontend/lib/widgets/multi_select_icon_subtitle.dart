import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/data/constants.dart';

class MultiSelectIconSubtitle extends StatelessWidget {
  const MultiSelectIconSubtitle(
    {
      super.key,
      required this.icon,
      required this.name,
      required this.activeCards,
    }
  );

  final String icon;
  final String name;
  final List<String> activeCards;

  @override
  Widget build(BuildContext context) {
    bool isActive = activeCards.contains(name);
    return Stack(
        children: [
          Container(
            width: 120.0,
            height: 110.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: isActive? lightOrange : lightGreen,
              border: Border.all(
                color: isActive ? orange : Colors.transparent,
                width: 2.0
              )
            ),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    icon,
                    width: 30,
                    height: 30,
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
          ),
          if(isActive)...[
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: orange
                ),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              )
            )
          ]
        ],
      );
  }
}