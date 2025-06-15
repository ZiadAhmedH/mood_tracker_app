class RelaxationExerciseModel {
  final String title;
  final String image;
  final List<String> instructions;
  final String? audioPath;

  RelaxationExerciseModel({
    required this.title,
    required this.image,
    required this.instructions,
    this.audioPath,
  });
}
