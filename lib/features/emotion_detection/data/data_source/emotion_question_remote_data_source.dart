import 'package:moodtracker_app/features/emotion_detection/data/data_source/emotion_assessment_questions.dart';
import 'package:moodtracker_app/features/emotion_detection/data/models/question_model.dart';

abstract class EmotionQuestionRemoteDataSource {
  Future<List<EmotionQuestionModel>> getQuestions();
}

class EmotionQuestionRemoteDataSourceImpl implements EmotionQuestionRemoteDataSource {
  @override
  Future<List<EmotionQuestionModel>> getQuestions() async {
    return emotionAssessmentQuestions
        .map((e) => EmotionQuestionModel.fromJson(e))
        .toList();
  }
}
