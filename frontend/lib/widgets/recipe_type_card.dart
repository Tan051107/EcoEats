
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/pages/cookbook_list.dart';

class RecipeTypeCard extends StatelessWidget {
  const RecipeTypeCard(
    {
      super.key,
      required this.iconColor,
      required this.icon,
      required this.name,
      required this.subtitle,
      required this.bgColor
    }
  );

  final String name;
  final String subtitle;
  final Color iconColor;
  final IconData icon;
  final LinearGradient bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context){
              return CookbookList(recipeType: name , icon: icon, iconColor: iconColor);
            })
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient:bgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 40.0,
                  color: iconColor,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: subtitleText.fontSize,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: subtitleText.color
                  ),
                )
              ],
            )
          ),
      ),
    );
  }
}