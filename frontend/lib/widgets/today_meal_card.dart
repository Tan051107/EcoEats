import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TodayMealCard extends StatefulWidget {
  const TodayMealCard(
    {
      super.key,
      required this.mealName,
      required this.calories,
      required this.eatenTime,
      required this.images
    }
  );

  final String mealName;
  final int calories;
  final String eatenTime;
  final List<String> images;

  @override
  State<TodayMealCard> createState() => _TodayMealCardState();
}

class _TodayMealCardState extends State<TodayMealCard> {
  late String imageUrl = "";

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    if (widget.images.isNotEmpty && widget.images[0].isNotEmpty) {
      try {
        final storageRef = FirebaseStorage.instance.refFromURL(widget.images[0]);
        final downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print("Error loading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:BorderRadius.circular(12),
                      color: lightGreen
                    ),
                    child:Padding(
                      padding: EdgeInsets.all(10.0),
                      child: imageUrl.isNotEmpty
                            ?Image.network(
                              imageUrl,
                              height: 40,
                              width: 40,
                            )
                            :Icon(
                              Icons.fastfood,
                              size: 40,
                            ),
                    )
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mealName,
                          style: TextStyle(
                            fontSize: subtitleText.fontSize,
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Text(
                          widget.eatenTime,
                          style:subtitleText
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  widget.calories.toString(),
                  style: TextStyle(
                    fontSize: subtitleText.fontSize,
                    fontWeight: FontWeight.bold
                  ),             
                ),
                Text(
                  "kcal",
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}