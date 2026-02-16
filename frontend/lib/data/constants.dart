import 'package:flutter/material.dart';

const TextStyle headerText = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.black
);

const TextStyle subtitleText = TextStyle(
fontSize: 18,
color: Color.fromARGB(255, 99, 98, 98)
);

const TextStyle headingTwoText = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.bold
);

const Color normalGreen = Color(0xFF2BAD5B);
const Color lightGreen = Color(0xFFE2EDE5);
const Color darkGreen = Color(0xFF267A3D);

const Color orange = Color(0xFFEB6B3E);



class ElevatedButtonStyle{
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor:normalGreen
  );

  static const TextStyle elevatedButtonTextStyle = TextStyle(
    color: darkGreen,
    fontWeight: FontWeight.bold
  );
}