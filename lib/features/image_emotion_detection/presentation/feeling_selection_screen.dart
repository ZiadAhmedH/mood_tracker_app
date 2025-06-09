import 'package:flutter/material.dart';

class FeelingSelectionScreen extends StatelessWidget {
  final String userFeeling;

  const FeelingSelectionScreen({super.key, required this.userFeeling});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Emotion")),
      body: Center(
        child: Text(
          'Detected Emotion: $userFeeling',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
