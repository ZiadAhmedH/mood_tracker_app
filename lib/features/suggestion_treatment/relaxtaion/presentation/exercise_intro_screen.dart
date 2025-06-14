import 'package:flutter/material.dart';

class ExerciseIntroScreen extends StatelessWidget {

  ExerciseIntroScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3C8F4), // خلفية بنفسجية فاتحة
      appBar: AppBar(
        backgroundColor: Color(0xFFF3C8F4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Exercise Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'For best performance\nplease insert headphone\nbefore starting journey',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.5, // المسافة بين الأسطر
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, nextRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9B27B0), // البنفسجي الداكن
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Start Journey',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/images/image.png', // تأكد من وجود الصورة في هذا المسار
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
