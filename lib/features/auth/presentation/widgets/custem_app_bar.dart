import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
AppBar buildAppBar(BuildContext context, {required String title, bool showLeading = true}) {
  return AppBar(
    title: Hero(
        tag: 'logo',
        child: SvgPicture.asset(
          'assets/icons/mood_mate_logo.svg',
          height: 30,
          width: 30,
        ),
      ),
    backgroundColor: Colors.white,
    centerTitle: true,
    automaticallyImplyLeading: showLeading,
    leading: showLeading
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () => Navigator.of(context).pop(),
          )
        : null,
  );
}



  