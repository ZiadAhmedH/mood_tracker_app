import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:moodtracker_app/core/constants/surah_list.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/data/models/surah_play_back_model.dart';
import 'package:moodtracker_app/features/suggestion_treatment/quran/presentation/controller/surah_playback_controller.dart';

class PlaySurah extends StatefulWidget {
  final int surahIndex;
  final String surahName;

  const PlaySurah({
    super.key,
    required this.surahIndex,
    required this.surahName,
  });

  @override
  _PlaySurahState createState() => _PlaySurahState();
}

class _PlaySurahState extends State<PlaySurah> {
  late int currentSurahIndex;
  late String currentSurahName;
  final controller = SurahPlaybackController();

  @override
  void initState() {
    super.initState();
    currentSurahIndex = widget.surahIndex;
    currentSurahName = widget.surahName;

    controller.audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        changeSurah(true);
      }
    });

    controller.playSurah(currentSurahIndex);
  }

  void _togglePlayPause() async {
    if (controller.isPlaying) {
      await controller.pause();
    } else {
      await controller.playSurah(currentSurahIndex);
    }
    setState(() {});
  }

  void changeSurah(bool next) async {
    final newIndex = next ? currentSurahIndex + 1 : currentSurahIndex - 1;
    if (newIndex >= 0 && newIndex < surahNames.length) {
      setState(() {
        currentSurahIndex = newIndex;
        currentSurahName = surahNames[newIndex];
      });
      await controller.playSurah(newIndex);
    }
  }

  @override
  void dispose() {
    // Do not dispose the audio player here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller.isPlaying;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, SurahPlaybackResult(index: currentSurahIndex, isPlaying: isPlaying)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              padding: EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "${currentSurahIndex + 1}",
                  style: TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: Color(0xFF9616FF)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              currentSurahName,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF9616FF)),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 226,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, size: 40, color: Color(0xFF9616FF)),
                    onPressed: () => changeSurah(false),
                  ),
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF9616FF),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, size: 40, color: Color(0xFF9616FF)),
                    onPressed: () => changeSurah(true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
