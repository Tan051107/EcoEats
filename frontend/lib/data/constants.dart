import 'package:flutter/material.dart';

class HeaderTextStyle{
  static const TextStyle headerText = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitleText = TextStyle(
    fontSize: 16,
    color: Colors.grey
  );
}

class ElevatedButtonStyle{
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor:Color(0xFFE2EDE5)
  );

  static const TextStyle elevatedButtonTextStyle = TextStyle(
    color: Color(0xFF267A3D),
    fontWeight: FontWeight.bold
  );
}