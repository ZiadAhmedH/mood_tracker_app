import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/emotion_question.dart';
import '../../domain/usecases/fetch_emotion_questions.dart';

part 'emotion_question_state.dart';

class EmotionQuestionCubit extends Cubit<EmotionQuestionState> {
  final FetchEmotionQuestions fetchEmotionQuestions;

  EmotionQuestionCubit(this.fetchEmotionQuestions) : super(EmotionQuestionInitial());

  List<EmotionQuestion> _questions = [];
  final Map<int, int> _selectedAnswerIndices = {}; 

  Future<void> loadQuestions() async {
    emit(EmotionQuestionLoading());
    final result = await fetchEmotionQuestions();
    result.fold(
      (failure) => emit(EmotionQuestionError(failure.message)),
      (questions) {
        _questions = questions;
        emit(EmotionQuestionLoaded(
          questions: questions,
          selectedAnswers: _selectedAnswerIndices,
          totalScore: _calculateTotalScore(),
        ));
      },
    );
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    _selectedAnswerIndices[questionIndex] = answerIndex;
    emit(EmotionQuestionLoaded(
      questions: _questions,
      selectedAnswers: Map.from(_selectedAnswerIndices),
      totalScore: _calculateTotalScore(),
    ));
  }

  int _calculateTotalScore() {
    int total = 0;
    for (var entry in _selectedAnswerIndices.entries) {
      final question = _questions[entry.key];
      final selectedAnswer = question.options[entry.value];
      total += selectedAnswer.score;
    }
    return total;
  }

  String getMoodFromScore(int score) {
  if (score >= 15) return 'happy';
  if (score >= 10) return 'naturally';
  if (score >= 5) return 'fear';
  if (score >= 0) return 'disgust';
  if (score >= -5) return 'sad';
  if (score < -5) return 'angry';
  return 'Unknown 🤷‍♂️';
}

}
