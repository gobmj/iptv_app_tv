import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    MaterialApp(
      home: IPTVPlayer(),
    ),
  );
}

class IPTVPlayer extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
      LogicalKeySet(LogicalKeyboardKey.enter): SelectIntent()
    }, child: IPTVPlayer());
  }

  _IPTVPlayerState createState() => _IPTVPlayerState();
}

class _IPTVPlayerState extends State<IPTVPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://j78dp346yq5r-hls-live.5centscdn.com/safari/live.stream/playlist.m3u8',
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
