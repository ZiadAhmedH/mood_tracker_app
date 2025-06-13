import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/features/home/Presentation/main_view.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';
import '../quran/presentation/quran_view/quran_view.dart';

class SuggestionBodyView extends StatelessWidget {
  final String mood;
  const SuggestionBodyView({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              buildOption(context, "assets/images/quran.png", isQuran: true),
              buildOption(context, "assets/images/book.png", isBook: true),
              buildOption(
                context,
                "assets/images/videos.png",
                isVideo: true,
              ), 
              buildOption(
                context,
                "assets/images/broadcast.png",
                isBroadcast: true,
              ),
              buildOption(context, "assets/images/relaxation.png"),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 382,
          height: 70,
          child: ElevatedButton(
            onPressed: () async {
  context.read<MoodStatsCubit>().saveUserMood(
    mood: mood,
    createdAt: DateTime.now(),
  );

  final snackBar = SnackBar(
    content: Text("Your mood has been saved successfully"),
    duration: Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  await Future.delayed(Duration(seconds: 2));

  Navigator.pushNamedAndRemoveUntil(
    context,
    MainView.routeName,
    (route) => false,
  );
},

            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF9616FF),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "End Session",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 21),
      ],
    );
  }

  Widget buildOption(
    BuildContext context,
    String imagePath, {
    bool isQuran = false,
    bool isBook = false,
    bool isVideo = false,
    bool isBroadcast = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (isQuran) {
          Navigator.pushNamed(context, QuranView.routeName);
        } else if (isBook) {
        } else if (isVideo) {
        } else if (isBroadcast) {
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
