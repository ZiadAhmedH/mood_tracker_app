import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:moodtracker_app/core/constants/logo_assets.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_v2/tflite_v2.dart';

class EmotionModelService {
  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: Assets.assetsModelsEmotiondetectorModel,
      labels: Assets.assetsModelsLabels,
    );
  }

  static Future<List?> runModelOnImage(File image) async {
    return await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
  }

  static Future<void> disposeModel() async {
    await Tflite.close();
  }
}

class CameraWithGalleryPicker extends StatefulWidget {
  const CameraWithGalleryPicker({super.key});

  @override
  State<CameraWithGalleryPicker> createState() => _CameraWithGalleryPickerState();
}

class _CameraWithGalleryPickerState extends State<CameraWithGalleryPicker> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _imagePath;
  bool _isProcessing = false;
  String? _prediction;

  @override
  void initState() {
    super.initState();
    _initCamera();
    EmotionModelService.loadModel();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    EmotionModelService.disposeModel();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission denied')),
      );
    }

    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _cameraController = CameraController(_cameras![0], ResolutionPreset.medium);
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing camera')),
        );
      }
    }
  }

  Future<void> _processImage(File image) async {
    setState(() {
      _isProcessing = true;
    });

    final result = await EmotionModelService.runModelOnImage(image);

    setState(() {
      _prediction = result != null && result.isNotEmpty ? result[0]["label"] : "Could not detect";
      _isProcessing = false;
    });
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _cameraController == null) return;

    try {
      final XFile picture = await _cameraController!.takePicture();
      setState(() {
        _imagePath = picture.path;
      });
      await _processImage(File(picture.path));
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        await _processImage(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                clipBehavior: Clip.hardEdge,
                child: _imagePath != null
                    ? Image.file(File(_imagePath!), fit: BoxFit.cover)
                    : _isCameraInitialized && _cameraController != null
                        ? CameraPreview(_cameraController!)
                        : Center(
                            child: Lottie.asset(
                              Assets.assetsLottieCameraLoading,
                              width: 100,
                              height: 100,
                            ),
                          ),
              ),
              if (_isProcessing)
                LinearProgressIndicator(color: AppColors.primary),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryLight,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.photo_library, size: 36, color: AppColors.primary),
                            onPressed: _pickImageFromGallery,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryLight,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: 36, color: AppColors.primary),
                            onPressed: _takePicture,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_imagePath != null)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.grayHeavyLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "  ${_imagePath!.split('/').last}",
                              color: AppColors.gray,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            IconButton(
                              icon: SvgPicture.asset(Assets.assetsIconsTrash, width: 20),
                              onPressed: () {
                                setState(() {
                                  _imagePath = null;
                                  _prediction = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    if (_prediction != null && !_isProcessing)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Detected Emotion: $_prediction",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: ElevatedButton(
            onPressed: () {
              if (_imagePath == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No image selected'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              print('Selected image path: $_imagePath');
              print('Detected emotion: $_prediction');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.07),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: CustomText(
              text: "Done",
              color: AppColors.graylight,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
