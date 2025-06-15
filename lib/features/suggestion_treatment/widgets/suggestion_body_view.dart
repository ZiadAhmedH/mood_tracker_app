import 'package:flutter/material.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/features/suggestion_treatment/books/presentation/book_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/rate_mood_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/relaxtaion/presentation/relaxation_exercises_view.dart';
import 'package:moodtracker_app/features/suggestion_treatment/videos/presentation/videos_view.dart';

import '../quran/presentation/quran_view/quran_view.dart';

class SuggestionBodyView extends StatelessWidget {
  final String mood;

  const SuggestionBodyView({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please tap 'End Session' to exit."),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryLight,
          ),
        );
        return false; // Prevent actual pop
      },
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildOption(context, "assets/images/quran.png", isQuran: true),
                buildOption(context, "assets/images/book.png", isBook: true),
                buildOption(context, "assets/images/videos.png", isVideo: true),
                buildOption(context, "assets/images/broadcast.png",isBroadcast: true,),
                buildOption(context, "assets/images/relaxation.png" , isRelaxation: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 382,
            height: 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RateMoodView.routeName ,                          
                arguments: {'userFeeling': mood},
);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9616FF),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "End Session",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 21),
        ],
      ),
    );
  }

  Widget buildOption(
    BuildContext context,
    String imagePath, {
    bool isQuran = false,
    bool isBook = false,
    bool isVideo = false,
    bool isBroadcast = false,
    bool isRelaxation = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isQuran) {
          Navigator.pushNamed(context, QuranView.routeName);
        } else if (isBook) {
          Navigator.pushNamed(context, BooksView.routeName);
        } else if (isVideo) {
           Navigator.pushNamed(context, VideosView.routeName, arguments: {'mood': mood});
        } else if (isBroadcast) {
          // Broadcast logic
        }
        else if(isRelaxation){
          Navigator.pushNamed(context, RelaxationExercisesView.routeName);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
