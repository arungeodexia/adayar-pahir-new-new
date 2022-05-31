//import 'package:flutter/services.dart';
import 'dart:io';


import 'package:ACI/data/globals.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class BGVideoPlayerView extends StatefulWidget {
  String videoUrl;
  String title;
  String local;

  BGVideoPlayerView({required this.videoUrl, required this.title, required this.local});

  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BGVideoPlayerView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    globalAndroidIsOnMsgExecuted = false;
    globalAndroidIsOnResumeExecuted = false;
    if (widget.local == "yes") {
      _controller = VideoPlayerController.file(
        //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
        File(widget.videoUrl),
      )..initialize().then((_) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.network(
        //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
        widget.videoUrl,
      )..initialize().then((_) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);
    Future<bool> onWillPop() async {
      //Go to Dashboard
      Navigator.pop(context);
      globalISPNPageOpened = false;
      return false;
    }


    final size = MediaQuery.of(context).size;
    // final deviceRatio = (size.width-10) / (size.height-250.0);
    final deviceRatio = (size.width) / (size.height);
    print("deviceRatio " + deviceRatio.toString());
    print("size width " + size.width.toString());
    print("size height " + size.height.toString());
    return new WillPopScope(
        onWillPop: () => onWillPop(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                onWillPop();
              },
            ),
            title: Text(widget.title),
            centerTitle: true,
          ),
          //body: Center(child: VideoPlayer(_controller)),
          body: Stack(
            children: <Widget>[
              _controller.value.isInitialized
                  ? SizedBox.expand(
                      child: FittedBox(
                        //fit: BoxFit.cover,
                        //fit: BoxFit.fitWidth,
                        fit: BoxFit.contain,
                        child: SizedBox(
                          // width: (_controller.value.size?.width - 20.0) ?? 0,
                          //height: size.height -10.0 ?? 0,
                          // width: (size.width - 10.0) ?? 0,

                          height: _controller.value.size.height-200,
                          width: (_controller.value.size.width-200),
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      ),
                    ),
            ],
          ),

          /*body: Transform.scale(
    scale: _controller.value.aspectRatio / (deviceRatio),
    child: Center(
    child: AspectRatio(
    aspectRatio: _controller.value.aspectRatio,
    child: VideoPlayer(_controller),
    ),
    ),),*/
        ));

    /*final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: _controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );*/
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
