import 'package:dartz/dartz.dart';
import 'package:moodtracker_app/core/errors/faliure.dart';
import 'package:moodtracker_app/features/image_emotion_detection/data/data_source/emotion_question_remote_data_source.dart';
import 'package:moodtracker_app/features/image_emotion_detection/domain/repo/emotion_question_repository.dart';
import '../../domain/entities/emotion_question.dart';

class EmotionQuestionRepositoryImpl implements EmotionQuestionRepository {
  final EmotionQuestionRemoteDataSource remoteDataSource;

  EmotionQuestionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<EmotionQuestion>>> fetchQuestions() async {
    try {
      final questions = await remoteDataSource.getQuestions();
      return Right(questions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
