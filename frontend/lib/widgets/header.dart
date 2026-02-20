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
      required this.isShowBackButton
    }
  );

  final String? subtitle;
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final bool isShowBackButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding:EdgeInsets.only(left:16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if(isShowBackButton)...[
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
                    )],
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
                        fontWeight: headerText.fontWeight,
                        fontSize: headerText.fontSize
                      ),
                    )
                  ],
                ),
                if(subtitle != null)...[
                  SizedBox(height: 5),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: subtitleText.fontSize,
                      color: subtitleText.color
                    ),
                  )
              ]
            ],
            ),
          ),
      ],
    );
  }
}