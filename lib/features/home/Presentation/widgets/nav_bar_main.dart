import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/profile/presentation/profile_view.dart';

AppBar buildAppBarMain(
  BuildContext context, {
  required String title,
  bool showLeading = true,
}) {



  return AppBar(
    title: CustomText(
      text: "Mood Tracker",
      color: AppColors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.white,
    centerTitle: true,
    automaticallyImplyLeading: showLeading,
    elevation: 0,
    
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context,ProfileView.routeName);
          },
          child: CircleAvatar(
            radius: 20,
            child:Icon(Icons.person_outline, color: AppColors.black, size: 20,) ,
          ),
        ),
      ),
    ],
  );
}
