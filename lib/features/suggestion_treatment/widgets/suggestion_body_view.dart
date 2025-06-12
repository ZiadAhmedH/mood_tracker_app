import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/mood_stat_cubit.dart';

import '../quran/presentation/quran_view/quran_view.dart';

class SuggestionBodyView extends StatelessWidget {
  const SuggestionBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildOption(context, "assets/images/quran.png", isQuran: true),
                  buildOption(context, "assets/images/book.png", isBook: true),
                  buildOption(context, "assets/images/videos.png", isVideo: true), // ✅ البحث عن فيديوهات
                  buildOption(context, "assets/images/broadcast.png", isBroadcast: true),
                  buildOption(context, "assets/images/relaxation.png"),
                ],
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 382,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  context.read<MoodStatsCubit>().saveUserMood(
                    mood: "happy",
                    createdAt: DateTime.now(),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 21),
          ],
        );
  }

   Widget buildOption(BuildContext context, String imagePath, {bool isQuran = false, bool isBook = false, bool isVideo = false, bool isBroadcast = false}) {
    return GestureDetector(
      onTap: () {
        if (isQuran) {
          Navigator.pushNamed(context, QuranView.routeName);
        } else if (isBook) {
         // Navigator.push(context, MaterialPageRoute(builder: (context) => ReadBooksScreen()));
        } else if (isVideo) { // ✅ البحث عن الفيديوهات عند الضغط
         // Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubeSearchScreen(query: "relaxing music")));
        } else if (isBroadcast) {
         // Navigator.push(context, MaterialPageRoute(builder: (context) => BroadcastAudioScreen()));
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