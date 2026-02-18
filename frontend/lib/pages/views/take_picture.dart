
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/widgets/take_picture_frame.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class TakePicture extends StatefulWidget {
  const TakePicture(
    {
      super.key,
    }
  );


  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {

  final ImagePicker _imagePicker = ImagePicker();
  final int maxImages = 3;
  bool _isTakingPicture = true;

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


  Future<void>pickImageFromGallery()async{
    final selectedImages = await _imagePicker.pickMultiImage();

    if(selectedImages.isNotEmpty){
      for(var selectedImage in selectedImages){
        if(images.length < maxImages){
          images.add(selectedImage);
        }
      }
      setState(() {
        if(selectedImages.isNotEmpty) {
          _isTakingPicture = false;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();  
  }

  void setIsTakingPicture(bool isTakingPicture){
    setState(() {
      _isTakingPicture = isTakingPicture;
    });
  }

  void emptyImages(){
    setState(() {
      images = [];
    });
  }

  void removeImage(int index){
    setState(() {
      images.removeAt(index);
    });
  }

  void returnToPreviousPage(){
    selectedPageNotifier.value = previousPageNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isTakingFoodPictureNotifier, 
      builder: (context,isTakingFoodPicture,child){
        return Scaffold(
          appBar: AppBar(
            leading:Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed:() => returnToPreviousPage(), 
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              )
            ),
            title: Text(
              isTakingFoodPicture ? "Scan Food" : "Scan Grocery"
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  PictureTypeSelectionBar(
                    emptyImages: emptyImages,
                  ),
                  SizedBox(height: 15.0),
                  _isTakingPicture
                  ?TakePictureSection(
                    addImage: addImage,
                    pickImageFromGallery:pickImageFromGallery,
                    imagesTaken: images,
                    setIsTakingPicture: setIsTakingPicture,
                  )
                  :ShowTakenPicturesSection(
                    setIsTakingPicture: setIsTakingPicture, 
                    imagesTaken: images,
                    removeImage: removeImage,
                  )
                ],
              )
            ),
          ),
        );
      }
    );
  }
}

class PictureTypeSelectionBar extends StatefulWidget {
  const PictureTypeSelectionBar(
    {
      super.key,
      required this.emptyImages
    }
  );

  final VoidCallback emptyImages;

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
                          isTakingFoodPictureNotifier.value = true;
                          widget.emptyImages();
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
                          isTakingFoodPictureNotifier.value = false;
                          widget.emptyImages();      
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

class TakePictureSection extends StatefulWidget {
  const TakePictureSection(
    {
      super.key,
      required this.addImage,
      required this.setIsTakingPicture,
      required this.pickImageFromGallery,
      required this.imagesTaken
    }
  );

  final ValueChanged<XFile> addImage;
  final ValueChanged<bool>setIsTakingPicture;
  final VoidCallback pickImageFromGallery;
  final List<XFile> imagesTaken;

  @override
  State<TakePictureSection> createState() => _TakePictureSectionState();
}

class _TakePictureSectionState extends State<TakePictureSection> {

  CameraController? cameraController;
  List<CameraDescription>? cameras;
  XFile? imageTaken;

  Future<void>initCamera()async{
    cameras =await availableCameras();
    cameraController = CameraController(
      cameras![0], 
      ResolutionPreset.high
    );

    await cameraController!.initialize();

    await cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);
    if(mounted){
      setState(() {});
    }
  }

  Future<void>takePicture()async{
    try{
      XFile image = await cameraController!.takePicture();
      setState(() {
        imageTaken = image;       
      });
    }
    catch(err){
      print("Error capturing photo: $err");
    }
  }

  void retakePicture(){
    setState(() {
      imageTaken = null;
    });
  }

  void confirmPicture(){
    if(imageTaken != null){
      widget.addImage(imageTaken!);
      widget.setIsTakingPicture(false);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if(imageTaken != null)...[
                SizedBox(
                  width: 350,
                  height: 350 * 4 / 3,
                  child: Image.file(
                    File(imageTaken!.path),
                    fit: BoxFit.contain,
                  ),
                ), 
              ]
              else if(cameraController != null && cameraController!.value.isInitialized)...[
                SizedBox(
                  width: 350,
                  height: 350 * 4 / 3,
                  child: CameraPreview(cameraController!),
                ),          
              ]
              else...[
                SizedBox(
                  width: 300,
                  height: 300 * 4 / 3,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
              SizedBox(
                width: 400,
                height: 400 * 4 / 3,
                child: CustomPaint(
                  painter: TakePictureFrame(),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: normalGreen,
                      width: 2.0
                    ),
                    borderRadius: BorderRadius.circular(25.0)
                  ),
                  child:Padding(
                    padding: EdgeInsets.all(17.0),
                    child:IconButton(
                      onPressed: () => widget.pickImageFromGallery(), 
                      icon: Icon(
                              Icons.image_outlined,
                              size: 30.0,
                            ),
                    )
                  ) ,
                ),
                GestureDetector(
                  onTap: () => imageTaken == null ? takePicture() : retakePicture(),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(167, 158, 158, 158)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4.0,
                            color:gray
                          )
                        ),
                        child: Icon(
                          imageTaken == null ? Icons.camera_alt_outlined : Icons.refresh_outlined,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: imageTaken != null,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: IconButton(
                    onPressed: () => confirmPicture(), 
                    icon: Icon(
                    Icons.check,
                    size: 40.0,
                    )
                  )
                )
              ],
            ),
          )
        ],
      ),
  );
  }
}

class ShowTakenPicturesSection extends StatefulWidget {
  const ShowTakenPicturesSection(
    {
      super.key,
      required this.setIsTakingPicture,
      required this.imagesTaken,
      required this.removeImage
    }
  );

  final ValueChanged<bool> setIsTakingPicture;
  final List<XFile> imagesTaken;
  final ValueChanged<int> removeImage;

  @override
  State<ShowTakenPicturesSection> createState() => _ShowTakenPicturesSectionState();
}

class _ShowTakenPicturesSectionState extends State<ShowTakenPicturesSection> {
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
                  children: [
                    SizedBox(
                        width: 400,
                        height: 400 * 4 / 3,
                        child: Image.file(
                        File(image.path),
                        fit: BoxFit.contain
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 50,
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
        if(widget.imagesTaken.length < 3)...[
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: normalGreen,
          ),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              "Scan",
              style: TextStyle(
                fontSize: headingTwoText.fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        )
      ]
    );
  }
}