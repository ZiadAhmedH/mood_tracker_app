import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/image_emotion_detection/domain/entities/emotion_question.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/cubits/emotion_question_cubit.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/feeling_selection_screen.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/widgets/question_section_view/question_body_view.dart';
import 'package:moodtracker_app/features/image_emotion_detection/presentation/widgets/question_section_view/section_header.dart';

class QuestionView extends StatelessWidget {
  static const String routeName = '/question_view';
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmotionQuestionCubit>()..loadQuestions(),
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: "Emotion Questions",
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.background),
            onPressed: () => Navigator.pop(context),
          ),
          excludeHeaderSemantics: true,
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<EmotionQuestionCubit, EmotionQuestionState>(
          builder: (context, state) {
            if (state is EmotionQuestionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmotionQuestionLoaded) {
              final grouped = <String, List<EmotionQuestion>>{};
              for (final q in state.questions) {
                grouped.putIfAbsent(q.category, () => []).add(q);
              }
              final categories = grouped.entries.toList();

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  ...categories.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(title: '${entry.key} Questions'),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: entry.value.length,
                          itemBuilder: (context, i) {
                            final question = entry.value[i];
                            return QuestionBodyView(question: question);
                          },
                        ),
                      ],
                    );
                  }).toList(),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      final state = context.read<EmotionQuestionCubit>().state;
                      if (state is EmotionQuestionLoaded) {
                        final mood = context
                            .read<EmotionQuestionCubit>()
                            .getMoodFromScore(state.totalScore);

                        Navigator.pushNamed(
                          context,
                          FeelingView.routeName,
                          arguments: {'userFeeling': mood},
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: CustomText(
                      text: "Submit",
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              );
            } else if (state is EmotionQuestionError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
