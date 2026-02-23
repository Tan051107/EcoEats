import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/data/constants.dart';

class ShowTakenPicturesSection extends StatefulWidget {
  const ShowTakenPicturesSection(
    {
      super.key,
      required this.setIsTakingPicture,
      required this.imagesTaken,
      required this.removeImage,
      required this.scanImageForDetails,
      required this.maxImages,
      required this.isLoadingToAnalyzeImage

    }
  );

  final ValueChanged<bool> setIsTakingPicture;
  final List<XFile> imagesTaken;
  final ValueChanged<int> removeImage;
  final VoidCallback scanImageForDetails;
  final int maxImages;
  final bool isLoadingToAnalyzeImage;


  @override
  State<ShowTakenPicturesSection> createState() => _ShowTakenPicturesSectionState();
}

class _ShowTakenPicturesSectionState extends State<ShowTakenPicturesSection> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
          ...List.generate(
          widget.imagesTaken.length,
          (index){
            final XFile image = widget.imagesTaken[index];
            return Column(
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(
                      File(image.path),
                      fit: BoxFit.contain
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child:                     
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: IconButton(
                                onPressed: () => widget.removeImage(index), 
                                icon: 
                                  Icon(
                                    Icons.close,
                                    size: 25.0,
                                  )
                              )
                            ),
                        )
                    )
                  ],
                ),
                SizedBox(height: 15.0)
              ],
            );
          }
        ),
        if(widget.imagesTaken.length < widget.maxImages)...[
          SizedBox(height: 15.0),
          DottedBorder(
            options: RectDottedBorderOptions(
              color: normalGreen,
              strokeWidth: 2.0,
              dashPattern: [6,3]
            ),
            child: GestureDetector(
              onTap: () => widget.setIsTakingPicture(true),
              child: SizedBox(
                width: 300,
                height: 300 * 4 / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 30,
                    ),
                    Text(
                      "Add New",
                      style: subtitleText,
                    )
                  ],
                ),
              ),
            )
          )
        ],
        SizedBox(height: 15.0),
        GestureDetector(
          onTap: ()=>widget.isLoadingToAnalyzeImage ? null :widget.scanImageForDetails(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isLoadingToAnalyzeImage ? normalGreen.withValues(alpha: 0.5) : normalGreen,
            ),
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: widget.isLoadingToAnalyzeImage
              ?CircularProgressIndicator()
              :Text(
                "Scan",
                style: TextStyle(
                  fontSize: headingTwoText.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              )
            ),
          ),
        )
      ]
    );
  }
}
