
import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
class CustemTextFormFeild extends StatelessWidget {

  final String hintText;
  final IconData iconData;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType textInputType;  


  const CustemTextFormFeild({super.key, required this.hintText, required this.iconData, required this.isPassword, required this.controller, required this.textInputType});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: isPassword,
      decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.gray1,
      ),
        border: borderBulider(),
        enabledBorder: borderBulider(),
        focusedBorder: borderBulider(),
        fillColor: AppColors.graylight,
        filled: true,
        suffixIcon: isPassword? Icon(iconData, color: AppColors.gray,) : null,
      ),
     
    );
  }

  OutlineInputBorder borderBulider() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grayHeavyLight ,width: 1),
      );
  }
}