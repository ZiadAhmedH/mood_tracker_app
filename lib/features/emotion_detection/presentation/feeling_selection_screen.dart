import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/features/emotion_detection/presentation/widgets/feeling_scetion_view/feeling_body_view.dart';

class FeelingView extends StatelessWidget {
     
  static const String routeName = '/feelingSelectionScreen';
  
  final String userFeeling;
  const FeelingView({super.key, required this.userFeeling});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detected Mode',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.background,
       body: FeelingBodyView(userFeeling: userFeeling),
    );
  }
}