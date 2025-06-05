
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/features/auth/presentation/sign_up_view.dart';
class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Don't have an account?",
        style: const TextStyle(
          color: AppColors.gray1,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
    
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
               Navigator.of(context).push(_createRoute());
              },
            text: " Create an Account",
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const SignUpView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(1.0, 0.0); 
      const endOffset = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: beginOffset, end: endOffset).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
