import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moodtracker_app/features/suggestion_treatment/relaxtaion/data/service/relaxation_exercise_service.dart';

import 'widgets/exercise_detail_view.dart';


class RelaxationExercisesView extends StatelessWidget {
  static const routeName = '/relaxation-exercises';

  const RelaxationExercisesView({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = RelaxationExerciseService.getExercises();

    return Scaffold(
      appBar: AppBar(title: const Text("Relaxation Exercises")),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseDetailView(exercise: ex),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Image.asset(ex.image, fit: BoxFit.cover),
                  ListTile(
                    title: Text(ex.title),
                    subtitle: Text(ex.title),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
