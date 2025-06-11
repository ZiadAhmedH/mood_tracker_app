import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioServiceImpl {
  final _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> play(String url, String title) async {
    await _player.setUrl(url);
    await _player.play();
    _showNotification(title);
  }

  Future<void> pause() async {
    await _player.pause();
    AudioServiceBackground.setState(playing: false);
  }

  Future<void> resume() async {
    await _player.play();
    AudioServiceBackground.setState(playing: true);
  }

  Future<void> stop() async {
    await _player.stop();
    AudioServiceBackground.setState(playing: false);
  }

  void _showNotification(String title) {
    AudioServiceBackground.setMediaItem(
      MediaItem(
        id: 'surah',
        album: 'Quran',
        title: title, // ← Now this uses the actual surah name
        artist: 'Qari Abdul Basit',
      ),
    );

    AudioServiceBackground.setState(
      controls: [
        MediaControl.pause,
        MediaControl.stop,
      ],
      playing: true,
      processingState: AudioProcessingState.ready,
    );
  }

  AudioProcessingState mapProcessingState(ProcessingState state) {
  switch (state) {
    case ProcessingState.idle:
      return AudioProcessingState.idle;
    case ProcessingState.loading:
    case ProcessingState.buffering:
      return AudioProcessingState.buffering;
    case ProcessingState.ready:
      return AudioProcessingState.ready;
    case ProcessingState.completed:
      return AudioProcessingState.completed;
    default:
      return AudioProcessingState.idle;
  }
}

}
