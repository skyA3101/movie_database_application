import 'package:movie_mania/core/utilities/imports.dart';

class YouTubePlayerWidget extends StatelessWidget {
  final String videoKey;

  const YouTubePlayerWidget({super.key, required this.videoKey});

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoKey,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          loop: true,
        ),
      ),
      showVideoProgressIndicator: true,
    );
  }
}
