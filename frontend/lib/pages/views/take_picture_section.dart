import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/widgets/take_picture_frame.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:frontend/data/constants.dart';

class TakePictureSection extends StatefulWidget {
  const TakePictureSection(
    {
      super.key,
      required this.addImage,
      required this.setIsTakingPicture,
      required this.pickImageFromGallery,
      required this.imagesTaken,
      required this.barcodeValue,
      required this.setBarcodeValue,
    }
  );

  final ValueChanged<XFile> addImage;
  final ValueChanged<bool>setIsTakingPicture;
  final VoidCallback pickImageFromGallery;
  final List<XFile> imagesTaken;
  final String barcodeValue;
  final ValueChanged<String>setBarcodeValue;

  @override
  State<TakePictureSection> createState() => _TakePictureSectionState();
}

class _TakePictureSectionState extends State<TakePictureSection> {

  CameraController? cameraController;
  List<CameraDescription>? cameras;
  XFile? imageTaken;
  final barcodeScanner = BarcodeScanner();

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

  void scanBarcodeInImage(XFile image)async{
    final inputImage = InputImage.fromFilePath(image.path);

    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    if(barcodes.isNotEmpty){
      String detectedBarcode = barcodes.first.displayValue!;
      widget.setBarcodeValue(detectedBarcode);
    }
    else{
      widget.setBarcodeValue("Empty barcode");
    }
  }

  void confirmPicture(){
    if(imageTaken != null){
      widget.addImage(imageTaken!);
      widget.setIsTakingPicture(false);
      if(widget.barcodeValue.isNotEmpty){
        scanBarcodeInImage(imageTaken!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();

  }

  @override
  void dispose() {
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
              else ...[
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
