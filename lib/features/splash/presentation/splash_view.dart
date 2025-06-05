import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/splash/presentation/widgets/splash_body_view.dart';

class SplashView extends StatelessWidget {

  static const String routeName = '/splash';
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBodyView(),
    );
  }
}