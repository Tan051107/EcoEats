
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:image_picker/image_picker.dart';

class TakePicture extends StatefulWidget {
  const TakePicture(
    {
      super.key,
      required this.isTakingFoodPicture
    }
  );

  final bool isTakingFoodPicture;

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {

  late bool _isTakingFoodPicture;
  final ImagePicker _imagePicker = ImagePicker();
  final int maxImages = 3;

  List<XFile> images = [];

  void showImageLimitWarning(){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maximum 3 images allowed")
      )
    );
  }

  void addImage(XFile image){
    if(images.length >= maxImages){
      showImageLimitWarning();
      return;
    }

    setState(() {
      images.add(image);
    });
  }

  Future<void> pickImageFromCamera()async{
    final image = await _imagePicker.pickImage(source: ImageSource.camera);

    if(image != null){
      addImage(image);
    }
  }

  Future<void>pickImageFromGallery()async{
    final selectedImages = await _imagePicker.pickMultiImage();

    if(selectedImages.isNotEmpty){
      for(var selectedImage in selectedImages){
        if(images.length < maxImages){
          images.add(selectedImage);
        }
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isTakingFoodPicture = widget.isTakingFoodPicture;  
  }

  void setIsTakingFoodPicture(bool isTakingFoodPicture){
    setState(() {
      _isTakingFoodPicture = isTakingFoodPicture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
        title: Text(
          _isTakingFoodPicture ? "Scan Food" : "Scan Grocery"
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PictureTypeSelectionBar(
              isTakingFoodPicture:_isTakingFoodPicture,
              setIsTakingFoodPicture: setIsTakingFoodPicture
            )
          ],
        )
      ),
    );
  }
}

class PictureTypeSelectionBar extends StatefulWidget {
  const PictureTypeSelectionBar(
    {
      super.key,
      required this.setIsTakingFoodPicture,
      required this.isTakingFoodPicture,
    }
  );

  final ValueChanged<bool> setIsTakingFoodPicture;
  final bool isTakingFoodPicture;

  @override
  State<PictureTypeSelectionBar> createState() => _PictureTypeSelectionBarState();
}

class _PictureTypeSelectionBarState extends State<PictureTypeSelectionBar> {
  @override
  Widget build(BuildContext context) {
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
                          widget.setIsTakingFoodPicture(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: widget.isTakingFoodPicture ? Colors.white : null
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
                          widget.setIsTakingFoodPicture(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: widget.isTakingFoodPicture ? null : Colors.white
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
}