import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';

class AuthCustomBtn extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onPressed;
  const AuthCustomBtn({
    super.key,
    required this.text,
    required this.onPressed,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
          ),
        ),

        child: ListTile(
          visualDensity: const VisualDensity(
            vertical: VisualDensity.minimumDensity,
          ),
          leading: SvgPicture.asset(image, width: 24, height: 24),
          title: CustomText(
            text: text,
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}