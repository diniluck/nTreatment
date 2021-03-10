import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  VideoPlayerPage(this.videoUrl);
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        //videoPlayerController.pause();
      });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: VideoPlayer(videoPlayerController),
    );
  }
}
