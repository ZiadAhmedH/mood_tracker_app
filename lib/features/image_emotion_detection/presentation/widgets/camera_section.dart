import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moodtracker_app/core/constants/logo_assets.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';

class CameraSection extends StatelessWidget {
  final bool isInitializing;
  final String? error;
  final String? imagePath;
  final bool isProcessing;
  final CameraController? cameraController;
  final bool isCameraInitialized;

  const CameraSection({
    super.key,
    required this.isInitializing,
    required this.error,
    required this.imagePath,
    required this.isProcessing,
    required this.cameraController,
    required this.isCameraInitialized,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              (isProcessing || imagePath != null)
                  ? AppColors.primary
                  : Colors.transparent,
          width: 2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isInitializing)
            _buildLoading()
          else if (error != null)
            _buildError(context)
          else if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(File(imagePath!), fit: BoxFit.cover),
            )
          else if (isCameraInitialized && cameraController != null)
            CameraPreview(cameraController!)
          else
            _buildLoading(),
          if (isProcessing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(Assets.assetsLottieCameraLoading, width: 100, height: 100),
        const SizedBox(height: 16),
        const Text(
          'Initializing camera...',
          style: TextStyle(color: AppColors.gray),
        ),
      ],
    ),
  );

  Widget _buildError(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
