import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late var chewieController;
  String url = "";

  @override
  void initState() {
    url = Get.parameters['video_url'] ??
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4";
    _controller = VideoPlayerController.network(
      url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
        autoInitialize: true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return Container(
                      color: Colors.black,
                      child: Chewie(controller: chewieController));
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            Positioned(
              top: 10,
              left: 20,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
