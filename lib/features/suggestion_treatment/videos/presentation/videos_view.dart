import 'package:flutter/material.dart';
import 'package:moodtracker_app/features/suggestion_treatment/videos/data/model/YoutubeVideoModel.dart';
import 'package:moodtracker_app/features/suggestion_treatment/videos/data/services/YoutubeSearchService.dart';
import 'package:moodtracker_app/features/suggestion_treatment/videos/presentation/widgets/shimmer_loading_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosView extends StatefulWidget {
  final String mood;

  static const String routeName = '/videos_view';
  const VideosView({super.key, required this.mood});

  @override
  State<VideosView> createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> {
  late Future<List<YoutubeVideoModel>> _videosFuture;
  final _service = YoutubeSearchService();

  @override
  void initState() {
    super.initState();
    _videosFuture = _service.fetchVideosForMood(widget.mood);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  Color getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.orangeAccent;
      case 'sad':
        return Colors.blueGrey;
      case 'angry':
        return Colors.redAccent;
      case 'neutral':
        return Colors.grey;
      case 'surprise':
        return Colors.purpleAccent;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = getMoodColor(widget.mood);

    return Scaffold(
      appBar: AppBar(
        title: Text('Boost "${widget.mood}" Mood'),
        backgroundColor: moodColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<YoutubeVideoModel>>(
        future: _videosFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ShimmerLoadingList());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          }

          final videos = snapshot.data ?? [];

          if (videos.isEmpty) {
            return Center(
              child: Text(
                'No videos found for mood "${widget.mood}"',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (ctx, i) {
              final video = videos[i];
              final controller = YoutubePlayerController(
                initialVideoId: video.videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: YoutubePlayer(
                        controller: controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: moodColor,
                        progressColors: ProgressBarColors(
                          playedColor: moodColor,
                          handleColor: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        video.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
