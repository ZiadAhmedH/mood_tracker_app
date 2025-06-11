part of 'emotion_question_cubit.dart';

abstract class EmotionQuestionState {}

class EmotionQuestionInitial extends EmotionQuestionState {}

class EmotionQuestionLoading extends EmotionQuestionState {}

class EmotionQuestionLoaded extends EmotionQuestionState {
  final List<EmotionQuestion> questions;
  final Map<int, int> selectedAnswers; 
  final int totalScore;

  EmotionQuestionLoaded({
    required this.questions,
    required this.selectedAnswers,
    required this.totalScore,
  });
}

class EmotionQuestionError extends EmotionQuestionState {
  final String message;

  EmotionQuestionError(this.message);
}
