import 'package:moodtracker_app/features/emotion_detection/domain/entities/answer_option.dart';
import '../../domain/entities/emotion_question.dart';

class EmotionQuestionModel extends EmotionQuestion {
  EmotionQuestionModel({
    required super.category,
    required super.questionText,
    required super.options,
  });

  factory EmotionQuestionModel.fromJson(Map<String, dynamic> json) {
    return EmotionQuestionModel(
      category: json['category'],
      questionText: json['question'],
      options: (json['answers'] as List)
          .map((answer) => AnswerOption.fromJson(answer))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'question': questionText,
        'answers': options.map((option) => option.toJson()).toList(),
      };
}
