import 'package:flutter/material.dart';
import 'exercise_intro_screen.dart';

class RelaxationExercisesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Relaxation Exercises',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          buildExerciseCard(
            context,
            'Deep Breathing',
            'This exercise helps calm the nervous system and reduce stress.',
            Icons.sentiment_satisfied,
            Colors.amber,
            'assets/images/image1.png',
            '/deep-breathing',
          ),
          SizedBox(height: 12),
          buildExerciseCard(
            context,
            'Muscle Relaxation',
            'This exercise helps release tension from your muscles.',
            Icons.fitness_center,
            Colors.purple,
            'assets/images/image2.png',
            '/muscle-relaxation',
          ),
          SizedBox(height: 12),
          buildExerciseCard(
            context,
            'Guided Meditation',
            'This exercise helps calm the mind and focus on the present moment.',
            Icons.spa,
            Colors.green,
            'assets/images/image3.png',
            '/guided-meditation',
          ),
        ],
      ),
    );
  }

  Widget buildExerciseCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color iconColor,
      String imagePath,
      String nextRoute) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseIntroScreen(nextRoute: nextRoute),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: iconColor.withOpacity(0.2),
                        child: Icon(icon, color: iconColor, size: 16),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 14),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
