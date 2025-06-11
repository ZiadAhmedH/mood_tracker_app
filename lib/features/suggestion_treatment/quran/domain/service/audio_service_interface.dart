abstract class IAudioService {
  Future<void> play(String url);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
}
