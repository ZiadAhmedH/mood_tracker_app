import 'package:flutter/material.dart';
class CustemButtom extends StatelessWidget {
  final Widget widget;
  final Color color;
  final VoidCallback onPressed;

  const CustemButtom({super.key, required this.widget, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child:widget ,
      ),
    );
  }
}