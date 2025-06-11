// domain/repositories/emotion_question_repository.dart
import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import '../entities/emotion_question.dart';

abstract class EmotionQuestionRepository {
  Future<Either<Failure, List<EmotionQuestion>>> fetchQuestions();
}
