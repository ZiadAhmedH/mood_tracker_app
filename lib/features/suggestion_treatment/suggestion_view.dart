import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/presentation/quran_view/quran_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/widgets/suggestion_body_view.dart';

class TreatmentSuggestionView extends StatelessWidget {
  static const String routeName = '/treatment_suggestion';
  const TreatmentSuggestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoodStatsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Let’s improve your mood",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {},
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          child: SuggestionBodyView(),
        ),
      ),
    );
  }
}
