import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoAppChewie extends StatefulWidget {
 final String videoUrl;
 final String title;

  const VideoAppChewie({Key? key, required this.videoUrl, required this.title}) : super(key: key);
  @override
  _VideoAppChewieState createState() => _VideoAppChewieState();
}

class _VideoAppChewieState extends State<VideoAppChewie> {
  late VideoPlayerController _controller;
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late Duration videoLength;
  late Duration videoPosition;
  @override
  void initState() {
    super.initState();
    print(widget.videoUrl.toString());
    // _controller = VideoPlayerController.network(
    //     widget.videoUrl)
    //   ..addListener(() => setState(() {
    //     videoPosition = _controller.value.position;
    //   }))
    //   ..initialize().then((_) => setState(() {
    //     _controller.play();
    //     _controller.setLooping(true);
    //     videoLength = _controller.value.duration;
    //   }));

    videoPlayerController = VideoPlayerController.network(
        widget.videoUrl)
      ..addListener(() => setState(() {
        videoPosition = videoPlayerController.value.position;
      }))
      ..initialize().then((_) => setState(() {
        videoPlayerController.play();
        videoPlayerController.setLooping(false);
        videoLength = videoPlayerController.value.duration;
      }));
    // await videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );

  }
  double volume = 0.5;
  @override
  Widget build(BuildContext context) {
    return
      // title: 'Video Demo',
       Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              },
          ),
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: videoPlayerController.value.isInitialized
              ? AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(
              controller: chewieController,
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
    videoPlayerController.pause();
    videoPlayerController.dispose();

    chewieController.dispose();
  }
}

String convertToMinutesSeconds(Duration duration) {
  final parsedMinutes = duration.inMinutes < 10
      ? '0${duration.inMinutes}'
      : duration.inMinutes.toString();

  final seconds = duration.inSeconds % 60;

  final parsedSeconds =
  seconds < 10 ? '0${seconds % 60}' : (seconds % 60).toString();
  return '$parsedMinutes:$parsedSeconds';
}

IconData animatedVolumeIcon(double volume) {
  if (volume == 0)
    return Icons.volume_mute;
  else if (volume < 0.5)
    return Icons.volume_down;
  else
    return Icons.volume_up;
}