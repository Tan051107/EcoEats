import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/modal/ManualAddGroceryFormData.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/grocery_service.dart';
import 'package:frontend/services/meal_service.dart';
import 'package:frontend/widgets/add_food_form.dart';
import 'package:frontend/widgets/add_grocery_form.dart';
import 'package:frontend/widgets/form_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'take_picture_section.dart';
import 'show_taken_pictures_section.dart';


class TakePicture extends StatefulWidget {
  const TakePicture({super.key});

  @override
  State<TakePicture> createState() => _TakePictureState();
}

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

class _TakePictureState extends State<TakePicture> {
  var uuid = Uuid();
  final BarcodeScanner barcodeScanner = BarcodeScanner();
  final ImagePicker _imagePicker = ImagePicker();
  int maxImages = isTakingFoodPictureNotifier.value ? 1 : 3;
  bool _isTakingPicture = true;
  String barCodeValueFound = "";
  bool isLoadingToAnalyzeImage = false;
  AuthService authService = AuthService();
  late String userId;

  List<XFile> images = [];
  List<String> imageUrls = [];

  String grocerySelected = "";

  void setGrocerySelected(String groceryLabel){
    setState(() {
      grocerySelected = groceryLabel;
    });
  }


  @override
  void initState() {
    super.initState();
    userId = authService.currentUser?.uid ?? "";
  }

  void switchPictureType(){
    setState(() {
      images = [];
    });
    isTakingFoodPictureNotifier.value = !isTakingFoodPictureNotifier.value;
    setState(() {
      maxImages = isTakingFoodPictureNotifier.value ? 1 : 3;
    });
    barCodeValueFound = "";
  }

  void showImageLimitWarning(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Maximum ${maxImages.toString()} images allowed")
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

  void setBarcodeValue(String barCodeValue){
    setState(() {
      barCodeValueFound = barCodeValue;
    });
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

  Future<void> scanBarcodeInImage(XFile image)async{
    final inputImage = InputImage.fromFilePath(image.path);
    print("Scanning barcode");
    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    if(barcodes.isNotEmpty){
      String detectedBarcode = barcodes.first.rawValue!;
      setState(() {
        barCodeValueFound = detectedBarcode;   
      });
    }
  }

  Future<void>scanBarCodeInAllImages()async{
    for (var image in images){
      if(barCodeValueFound.isNotEmpty){
        return;
      }
      await scanBarcodeInImage(image);    
    }
  }

  Future<String>uploadImage(XFile image)async{
    try{
      final imageFile = File(image.path);
      String uniqueId = uuid.v4();
      final String imageName = "$uniqueId-${image.name}"; 
      final storageRef = FirebaseStorage.instance.ref().child('users/$userId/${isTakingFoodPictureNotifier.value? "food" : "groceries"}/$imageName');
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot){
        final progress = snapshot.bytesTransferred/snapshot.totalBytes;
        print('users/$userId/${isTakingFoodPictureNotifier.value? "food" : "groceries"}/$imageName');
        print('Upload is ${(progress * 100).toStringAsFixed(2)}% done');
      },onError: (e){
        print("Upload Failed:$e");
      });

      final TaskSnapshot snapshot = await uploadTask;
      final path = snapshot.ref.fullPath;
      return path;


    }
    catch(err){
      throw Exception("Failed to upload new image to firebase storage:$err");
    }
  }

  Future <void> uploadImages()async{
    List<Future<String>> imagePaths = [];
    for (var image in images){
      imagePaths.add(uploadImage(image));
    }

    final uploadImageResult = await Future.wait(imagePaths);

    setState(() {
      imageUrls = uploadImageResult;
    });
  }

  Future<void> scanImageForDetails()async{
    if(images.isEmpty){
      debugPrint("imageUrls length: ${imageUrls.length}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please upload at least 1 image to analyze")
        )
      );
      return;
    }

    setState(() {
      isLoadingToAnalyzeImage = true;
    });

    late Map<String,dynamic> analyzedImageResult;

    try{
      debugPrint("Uploading images");
      await uploadImages();
      debugPrint("Images added successfully");
      debugPrint("Image urls:$imageUrls");
      if(isTakingFoodPictureNotifier.value){
        debugPrint("Analyzing food images");
        analyzedImageResult =  await MealService.sendFoodImagesForAnalysis(imageUrls);
      }
      else{
        debugPrint("Scanning grocery barcode");
        await scanBarCodeInAllImages(); 
        debugPrint("Barcode received: $barCodeValueFound"); 
        debugPrint("Analyzing Gorcery images");
        analyzedImageResult = await GroceryService.sendGroceryImagesForAnalysis(barCodeValueFound, imageUrls);
      }
      print(analyzedImageResult);
      showAddForm(anaylzedResult: analyzedImageResult);
    }
    catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to analyze images:$err")
        )
      );
      debugPrint(err.toString());
    }
    finally{
      if(mounted){
        setState((){
          isLoadingToAnalyzeImage = false;
        });
      }
    }
  }

  void showAddForm({Map<String,dynamic>? anaylzedResult})async{
    if(!isTakingFoodPictureNotifier.value){
      await showFormDialog<ManualAddGroceryFormData>(
        context: context, child: AddGroceryForm(returnedAnalyzedResult:anaylzedResult)
      );
    }
    else{
      await showFormDialog(
        context: context, 
        child: AddFoodForm(returnedAnalyzedResult:anaylzedResult)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isTakingFoodPictureNotifier, 
      builder: (context,isTakingFoodPicture,child){
        return Scaffold(
          appBar: AppBar(
            actions: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed:() =>showAddForm(), 
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                )
              ),    
            ],
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
                    switchPictureType: switchPictureType,
                  ),
                  SizedBox(height: 15.0),
                  _isTakingPicture
                  ?TakePictureSection(
                    addImage: addImage,
                    pickImageFromGallery:pickImageFromGallery,
                    imagesTaken: images,
                    setIsTakingPicture: setIsTakingPicture,
                    barcodeValue: barCodeValueFound,
                    setBarcodeValue: setBarcodeValue,
                  )
                  :ShowTakenPicturesSection(
                    isLoadingToAnalyzeImage: isLoadingToAnalyzeImage,
                    setIsTakingPicture: setIsTakingPicture, 
                    imagesTaken: images,
                    removeImage: removeImage,
                    maxImages: maxImages,
                    scanImageForDetails: scanImageForDetails,
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
