import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/data/constants.dart';

class PictureTypeSelectionBar extends StatefulWidget {
  const PictureTypeSelectionBar(
    {
      super.key,
      required this.switchPictureType
    }
  );

  final VoidCallback switchPictureType;

  @override
  State<PictureTypeSelectionBar> createState() => _PictureTypeSelectionBarState();
}

class _PictureTypeSelectionBarState extends State<PictureTypeSelectionBar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isTakingFoodPictureNotifier, 
      builder: (context,isTakingFoodPicture,child){
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(12.0)
              ),
              child:Padding(
                padding:EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.switchPictureType();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: isTakingFoodPicture ? Colors.white : null
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.set_meal,
                                  color: Colors.black,
                                ),
                                SizedBox(width:5.0),
                                Text(
                                  "Food",
                                  style: TextStyle(
                                    fontSize: subtitleText.fontSize,
                                    color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.switchPictureType();     
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: isTakingFoodPicture ? null : Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.trolley,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  "Grocery",
                                  style: TextStyle(
                                    fontSize: subtitleText.fontSize,
                                    color: Colors.black
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ) ,
            )
          ],
        );
      }
    );
  }
}
