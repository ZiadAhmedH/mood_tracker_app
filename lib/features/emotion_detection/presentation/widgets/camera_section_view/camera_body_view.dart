import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/emotion_detection/data/services/ImageCaptureService.dart';
import 'package:moodtracker_app/features/emotion_detection/data/services/face_emotaion_service.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/widgets/camera_section_view/action_section.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/widgets/camera_section_view/camera_section.dart';

class CameraWithGalleryPicker extends StatefulWidget {
  const CameraWithGalleryPicker({super.key});

  @override
  State<CameraWithGalleryPicker> createState() => _CameraWithGalleryPickerState();
}

class _CameraWithGalleryPickerState extends State<CameraWithGalleryPicker> {
  late final ImageCaptureService _imageService;
  String? _imagePath;
  bool _isProcessing = false;
  bool _isInitializing = true;
  String? _prediction;
  String? _error;

  @override
  void initState() {
    super.initState();
    _imageService = ImageCaptureService();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      setState(() => _isInitializing = true);
      await EmotionModelService.loadModel();
      final initialized = await _imageService.initCamera();
      setState(() {
        _isInitializing = false;
        _error = initialized ? null : 'Camera permission denied';
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _error = 'Failed to initialize services';
      });
    }
  }

  @override
  void dispose() {
    _imageService.disposeCamera();
    EmotionModelService.disposeModel();
    super.dispose();
  }

  Future<void> _processImage(File image) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      final prediction = await _imageService.processImage(image);
      setState(() {
        _prediction = prediction;
        _isProcessing = false;
      });
    } catch (_) {
      setState(() {
        _prediction = null;
        _isProcessing = false;
        _error = 'Failed to process image';
      });
    }
  }

  Future<void> _takePicture() async {
    if (_isProcessing || !_imageService.isCameraInitialized) return;
    final picture = await _imageService.takePicture();
    if (picture != null) {
      setState(() => _imagePath = picture.path);
      await _processImage(File(picture.path));
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;
    final pickedFile = await _imageService.pickImageFromGallery();
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
      await _processImage(File(pickedFile.path));
    }
  }

  void _clearImage() {
    setState(() {
      _imagePath = null;
      _prediction = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CameraSection(
            isInitializing: _isInitializing,
            error: _error,
            imagePath: _imagePath,
            isProcessing: _isProcessing,
            cameraController: _imageService.cameraController,
            isCameraInitialized: _imageService.isCameraInitialized,
          ),
        ),
        ActionSection(
          isProcessing: _isProcessing,
          imagePath: _imagePath,
          prediction: _prediction,
          error: _error,
          onPickImage: _pickImageFromGallery,
          onTakePicture: _takePicture,
          onClearImage: _clearImage,
        )
      ],
    );
  }
}

