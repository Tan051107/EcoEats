import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/data/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

Widget ShelfItemCard(
  {
    required BuildContext context,
    required final int estimatedShelfLife,
    required final String groceryName,
    required final String category,
    required final int quantity,
    final String? image,
    required final String unit
  }
){
  return FutureBuilder<String>(
    future: _getImageUrl(image),
    builder: (context, snapshot) {
      return _buildCard(
        context: context,
        estimatedShelfLife: estimatedShelfLife,
        groceryName: groceryName,
        category: category,
        quantity: quantity,
        imageUrl: snapshot.data ?? "",
        image: image,
        unit: unit

      );
    },
  );
}

Future<String> _getImageUrl(String? image) async {
  if (image != null && image.isNotEmpty) {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      return "";
    }
  }
  return "";
}

Widget _buildCard({
  required BuildContext context,
  required final int estimatedShelfLife,
  required final String groceryName,
  required final String category,
  required final int quantity,
  required final String imageUrl,
  final String? image,
  required final String unit
}){
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
      padding: EdgeInsets.all(10.0),
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
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (imageUrl.isNotEmpty)
                          ? Image.network(
                            imageUrl,
                            width: iconSize,
                            height: iconSize,
                            fit: BoxFit.cover
                          )
                          : SvgPicture.asset(
                            icon,
                            width: iconSize,
                            height: iconSize,
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
                    size: 18.0,
                    color: frameColor,
                  ),
                  SizedBox(width: 3.0),
                  Text(
                    "${estimatedShelfLife}d left",
                    style: TextStyle(
                      color: frameColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height:5.0),
          Text(
            groceryName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height:2.0),
          Text(
            "${quantity.toString()} $unit",
            style: TextStyle(
              color: gray,
              fontSize: 14.0
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height:2.0),
          Text(
            category.toString(),
            style: TextStyle(
              color: gray,
              fontSize: 14
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    )
  );
}