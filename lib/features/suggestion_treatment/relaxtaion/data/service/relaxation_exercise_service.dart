
import 'package:moodtracker_app/features/suggestion_treatment/relaxtaion/data/model/relaxation_exercise_model.dart';

class RelaxationExerciseService {
  static List<RelaxationExerciseModel> getExercises() {
    return [
      RelaxationExerciseModel(
        title: 'Deep Breathing Exercise',
        image: 'assets/images/breathing.png',
        instructions: [
          'Sit or lie down in a comfortable position.',
          'Place one hand on your chest and one on your stomach.',
          'Take a deep breath in through your nose…',
          'Hold your breath for 4 seconds…',
        ],
        audioPath: 'assets/audio/breathing.mp3',
      ),
      RelaxationExerciseModel(
        title: 'Progressive Muscle Relaxation',
        image: 'assets/images/muscle.png',
        instructions: [
          'Tense and relax different muscle groups...',
          'Focus on releasing tension from head to toe.',
        ],
        audioPath: 'assets/audio/step.mp3',
      ),
      RelaxationExerciseModel(
        title: 'Guided Meditation',
        image: 'assets/images/meditation.png',
        instructions: [
          'Close your eyes and focus on your breath.',
          'Visualize a peaceful place...',
        ],
        audioPath: 'assets/audio/breathing1.mp3',
      ),
    ];
  }
}
