import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodtracker_app/core/constants/logo_assets.dart';
import 'package:moodtracker_app/core/helper/shared_keys.dart';
import 'package:moodtracker_app/core/helper/shared_prefrence.dart';
import 'package:moodtracker_app/features/auth/presentation/login_view.dart';
import 'package:moodtracker_app/features/onBoarding/onboarding_screen1.dart';

class SplashBodyView extends StatefulWidget {
  const SplashBodyView({super.key});

  @override
  State<SplashBodyView> createState() => _SplashBodyViewState();
}

class _SplashBodyViewState extends State<SplashBodyView> {
  @override
  void initState() {
    super.initState();
    executeSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'logo',
          child: SvgPicture.asset(Assets.assetsIconsMoodMateLogo, height: 150),
        ),
      ),
    );
  }

  void executeSplashScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      bool isLogin = LocalDataCore.getData(key: SharedKey.isLogin) ?? false;
      bool isOnBoardingCompleted = LocalDataCore.getData(key: SharedKey.onBoarding) ?? false;
      
      if (isOnBoardingCompleted) {
        if (isLogin) {
          Navigator.pushNamedAndRemoveUntil(context, LoginView.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, LoginView.routeName, (route) => false);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(context, OnboardingScreen.routeName, (route) => false);
      }
    });
  }
}
