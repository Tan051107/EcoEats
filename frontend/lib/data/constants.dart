import 'package:flutter/material.dart';

const TextStyle headerText = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.black
);

const TextStyle subtitleText = TextStyle(
fontSize: 18,
color:gray
);


const TextStyle headingTwoText = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.bold
);

const TextStyle headingThreeText = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold
);

const TextStyle smallText = TextStyle(
  fontSize: 15,
  color: gray
);


const Color normalGreen = Color(0xFF2BAB56);
const Color lightGreen = Color(0xFFE2EDE5);
const Color darkGreen = Color(0xFF267A3D);

const Color lightOrange =  Color.fromRGBO(232, 118, 58, 0.1);
const Color orange = Color(0xFFEB6B3E);

const Color normalYellow = Color(0xFFF2B80C);
const Color lightYellow = Color(0x1AEBB517);

const Color normalBlue = Color(0xFF2AAEE6);

const Color gray = Color.fromARGB(255, 99, 98, 98);


class ElevatedButtonStyle{
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor:normalGreen
  );

  static const TextStyle elevatedButtonTextStyle = TextStyle(
    color: darkGreen,
    fontWeight: FontWeight.bold
  );
}