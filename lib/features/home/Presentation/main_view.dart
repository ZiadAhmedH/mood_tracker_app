import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/features/home/Presentation/widgets/main_body_view.dart';
import 'package:moodtracker_app/features/home/Presentation/widgets/nav_bar_main.dart';

class MainView extends StatelessWidget {
  static const String routeName = '/main';
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: buildAppBarMain(context, title: "Mood Tracker", showLeading: false),
      backgroundColor: AppColors.background,
       body: MainBodyView() ,
    );
  }
}