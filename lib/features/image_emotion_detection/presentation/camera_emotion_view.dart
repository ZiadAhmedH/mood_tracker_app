import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/widgets/camera_body_view.dart';

class CameraEmotionView extends StatelessWidget {

  static const String routeName = '/cameraEmotionView';
  const CameraEmotionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Take A Picture", color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w600, ),
        backgroundColor: Colors.white,
        centerTitle: true ,
      ),
      backgroundColor: AppColors.background,
      body: CameraWithGalleryPicker()
    );
  }
}