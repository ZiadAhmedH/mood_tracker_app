import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/emotion_question.dart';
import '../../cubits/emotion_question_cubit.dart';
import 'answer_option.dart';

class QuestionBodyView extends StatelessWidget {
  final EmotionQuestion question;
  const QuestionBodyView({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmotionQuestionCubit, EmotionQuestionState>(
      builder: (context, state) {
        if (state is EmotionQuestionLoaded) {
          final questionIndex = state.questions.indexOf(question);
          final selectedIndex = state.selectedAnswers[questionIndex];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(question.options.length, (index) {
                    final option = question.options[index];
                    return AnswerOption(
                      answer: option.text,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        context.read<EmotionQuestionCubit>().selectAnswer(questionIndex, index);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
