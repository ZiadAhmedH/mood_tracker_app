
import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';

class OrDividor extends StatelessWidget {
  const OrDividor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.grayHeavyLight,
          ),
        ),
        const SizedBox(width: 16,),
        Text.rich(
          TextSpan(
            text: "OR",
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16,),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.grayHeavyLight,
          ),
        ),
      ],
    );
  }
}