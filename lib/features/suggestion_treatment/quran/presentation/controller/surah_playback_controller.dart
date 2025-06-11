import 'package:just_audio/just_audio.dart';

class SurahPlaybackController {
  static final SurahPlaybackController _instance = SurahPlaybackController._internal();

  factory SurahPlaybackController() => _instance;

  late final AudioPlayer audioPlayer;
  int currentIndex = -1;
  bool isInitialized = false;

  SurahPlaybackController._internal() {
    audioPlayer = AudioPlayer();
  }

  Future<void> playSurah(int index) async {
    if (currentIndex != index || !isInitialized) {
      currentIndex = index;
      isInitialized = true;
      final url = "https://server8.mp3quran.net/afs/${(index + 1).toString().padLeft(3, '0')}.mp3";
      await audioPlayer.setUrl(url);
    }
    audioPlayer.play();
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  bool get isPlaying => audioPlayer.playing;

  Future<void> dispose() async {
    await audioPlayer.dispose();
    isInitialized = false;
  }
}
