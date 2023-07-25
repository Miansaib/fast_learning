import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MyOwnVideoPlayer extends StatelessWidget {
  final String link;
  MyOwnVideoPlayer(this.link);

  @override
  Widget build(BuildContext context) {
    // YoutubePlayerController _controller = YoutubePlayerController(
    //   initialVideoId: link,
    //   flags: YoutubePlayerFlags(
    //     disableDragSeek: true,
    //     controlsVisibleAtStart: true,
    //     autoPlay: false,
    //     hideControls: false,
    //     useHybridComposition: true,
    //   ),
    // );
    // TODO: implement build
    // return YoutubePlayer(
    //   controller: _controller,
    //   showVideoProgressIndicator: true,
    //   progressIndicatorColor: Colors.blueAccent,
    //   bottomActions: [
    //     CurrentPosition(),
    //     ProgressBar(isExpanded: true),
    //     RemainingDuration(),
    //   ],
    // );
    final _controller = YoutubePlayerController.fromVideoId(
      videoId: this.link,
      autoPlay: true,
      params: const YoutubePlayerParams(
          loop: true,
          strictRelatedVideos: false,
          showFullscreenButton: true,
          showVideoAnnotations: false,
          showControls: false),
    );
    return YoutubePlayer(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}

class LocalVideoPlayer extends StatelessWidget {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  final String link;
  LocalVideoPlayer(this.link, {Key? key}) : super(key: key);
  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoController = VideoPlayerController.network(this.link)..initialize();
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(true);

    // _videoController.setVolume(0);

    return Container(
      height: 200,
      child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_videoController.value.isInitialized)
                print(_videoController.value.aspectRatio);
              return Stack(children: [
                VideoPlayer(_videoController),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _videoController.play();
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.pause_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _videoController.pause();
                        },
                      ),
                    ],
                  ),
                ),
              ]);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
