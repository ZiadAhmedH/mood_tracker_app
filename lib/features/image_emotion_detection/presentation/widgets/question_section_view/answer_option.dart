import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';

class AnswerOption extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(answer, style:  TextStyle(fontSize: 15 ,color: isSelected ? AppColors.primary : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
      ),
    );
  }
}
