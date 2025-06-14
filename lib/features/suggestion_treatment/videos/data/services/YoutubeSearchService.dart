import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../model/YoutubeVideoModel.dart';

class YoutubeSearchService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<List<YoutubeVideoModel>> fetchVideosForMood(String mood) async {
    final query = 'videos to increase $mood';

    // Await the search results first
    final results = await _yt.search.search(query);

    // Take first 5 videos
    final videos = results.take(5).map((item) {
      return YoutubeVideoModel(
        videoId: item.id.value,
        title: item.title,
        thumbnail: item.thumbnails.highResUrl,
      );
    }).toList();

    return videos;
  }

  void dispose() {
    _yt.close();
  }
}
