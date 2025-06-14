import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/suggestion_treatment/widgets/rate_mood_body_view.dart';

class RateMoodView extends StatelessWidget {
  static const String routeName = '/rate_mood_view';
  final String userFeeling;

  const RateMoodView({super.key, required this.userFeeling});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoodStatsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rate Mood Progress'),
          centerTitle: true,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: RateMoodBodyView(userFeeling: userFeeling),
      ),
    );
  }
}
