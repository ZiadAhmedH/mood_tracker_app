import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  

  const CustomText({super.key, required this.text, required this.color, required this.fontSize, required this.fontWeight, this.textAlign});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, 
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
    
      ),
    );
  }
}