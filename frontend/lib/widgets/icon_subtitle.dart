import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class IconSubtitle extends StatelessWidget {
  const IconSubtitle({
    super.key,
    required this.icon,
    required this.name,
    required this.iconColor,
    required this.activeCard,
  });

  final IconData icon;
  final String name;
  final Color iconColor;
  final String activeCard;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Fixed card size for uniformity
    final cardWidth = screenWidth * 0.3;
    final cardHeight = max(cardWidth * 0.9, 120.0); // minimum height to fit text

    bool isActive = name == activeCard;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: lightGreen,
        border: Border.all(
          color: isActive ? normalGreen : Colors.transparent,
          width: 2.0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: cardHeight * 0.08,
        horizontal: cardWidth * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: cardHeight * 0.35,
            color: iconColor,
          ),
          SizedBox(height: cardHeight * 0.05),
          Text(
            name,
            style: smallText.copyWith(fontSize: 14), // uniform font size
            textAlign: TextAlign.center,
            maxLines: 2, // allow text to wrap to two lines
            overflow: TextOverflow.visible, // show full text
          ),
        ],
      ),
    );
  }
}