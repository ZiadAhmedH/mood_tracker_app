import 'package:flutter/material.dart';
import 'dart:math';
import 'package:moodtracker_app/core/utils/constants/surah_list.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/presentation/controller/surah_playback_controller.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/presentation/quran_view/surah_view_play.dart';

class QuranView extends StatefulWidget {
  static const String routeName = '/quranView';
  const QuranView({super.key});

  @override
  _ListenQuranState createState() => _ListenQuranState();
}

class _ListenQuranState extends State<QuranView> {
  final controller = SurahPlaybackController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Listen To Quran", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: surahNames.length,
        itemBuilder: (context, index) {
          bool isPlaying = controller.isPlaying && controller.currentIndex == index;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 29.5,
                  backgroundColor: Color(0xFFF1F1F1),
                  child: Text("${index + 1}", style: TextStyle(color: Color(0xFF9616FF), fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surahNames[index],
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF9616FF)),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 30,
                        child: isPlaying
                            ? Row(
                                children: List.generate(31, (i) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 1.95),
                                    child: Container(
                                      width: 4,
                                      height: Random().nextInt(30) + 10,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF9D7AFF),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                }),
                              )
                            : Text(
                                '------------------------------------------------------',
                                style: TextStyle(color: Color(0xFF9D7AFF), fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaySurah(
                          surahName: surahNames[index],
                          surahIndex: index,
                        ),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                  child: CircleAvatar(
                    radius: 29.5,
                    backgroundColor: isPlaying ? Color(0xFFEDE1FF) : Color(0x339D7AFF),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Color(0xFF9D7AFF),
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
