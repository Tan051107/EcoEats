import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class Header extends StatelessWidget {
  const Header(
    {
      super.key,
      required this.title,
      this.subtitle,
      this.icon,
      this.iconColor,
    }
  );

  final String? subtitle;
  final String title;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:EdgeInsets.only(top:50.0 , left:16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child:Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                    ),
                    child: Icon(Icons.arrow_back_ios_outlined),
                ),
                ),
                if(icon != null)...[
                  Icon(
                    icon,
                    color: iconColor,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: HeaderTextStyle.headerText.fontWeight,
                    fontSize: HeaderTextStyle.headerText.fontSize
                  ),
                )
              ],
            ),
            if(subtitle != null)..
              SizedBox(height: 5),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: HeaderTextStyle.subtitleText.fontSize,
                  color: HeaderTextStyle.subtitleText.color
                ),
              )
          ],
        ),
      );
  }
}