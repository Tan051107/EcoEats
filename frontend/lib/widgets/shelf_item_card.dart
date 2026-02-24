import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/data/constants.dart';

Widget ShelfItemCard(
  {
    required BuildContext context,
    required final int estimatedShelfLife,
    required final String groceryName,
    required final String category,
    required final int quantity,
    final String? image
  }
){
  Color frameColor = gray;
  Color bgColor = Colors.transparent;
  late String icon;
  double iconSize = (MediaQuery.of(context).size.width * 0.08).clamp(24, 30);
  

  switch(estimatedShelfLife){
    case < 3:
      frameColor = normalRed;
      bgColor = lightRed;
      break;
    case < 5:
      frameColor = normalYellow;
      bgColor = lightYellow;
      break;
    default:
      frameColor = gray;
      bgColor = Colors.transparent;
  }

  switch(category.toLowerCase()){
    case "fresh produce":
      icon = "assets/icons/salad.svg";
      break;
    case "packaged food":
      icon = "assets/icons/canned-food.svg";
      break;
    case "packaged beverage":
      icon = "assets/icons/milk.svg";    
  }

  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: frameColor,
        width: 2.0
      ),
      color: bgColor,
      borderRadius: BorderRadius.circular(12.0)
    ),
    child:Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(15.0)
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (image != null && image.isNotEmpty)
                          ?Image.network(
                            image,
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.contain,
                          )
                          :SvgPicture.asset(
                            icon,
                            width: iconSize,
                            height:iconSize,
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 20.0,
                    color: frameColor,
                  ),
                  SizedBox(width: 3.0),
                  Text(
                    "${estimatedShelfLife}d left",
                    style: TextStyle(
                      color: frameColor,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height:8.0),
          Flexible(
            child:Text(
              groceryName,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height:3.0),
          Flexible(
            child:Text(
              "$quantity g · $category",
              style: TextStyle(
                color: gray
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          )
        ],
      ),
    )
  );
}