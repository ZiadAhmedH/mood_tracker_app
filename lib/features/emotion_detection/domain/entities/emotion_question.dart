import 'answer_option.dart';

class EmotionQuestion {
  final String category;
  final String questionText;
  final List<AnswerOption> options;

  EmotionQuestion({
    required this.category,
    required this.questionText,
    required this.options,
  });
}
