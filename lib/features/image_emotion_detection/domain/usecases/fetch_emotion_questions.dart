import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/image_emotion_detection/domain/repo/emotion_question_repository.dart';
import '../entities/emotion_question.dart';

class FetchEmotionQuestions {
  final EmotionQuestionRepository repository;

  FetchEmotionQuestions(this.repository);

  Future<Either<Failure, List<EmotionQuestion>>> call() {
    return repository.fetchQuestions();
  }
}
