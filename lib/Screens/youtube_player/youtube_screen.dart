import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isPlayerReady = false;
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  String url = "";
  String videoId = "";

  @override
  void initState() {
    super.initState();
    url = Get.parameters['yt_url'] ?? "V7LwfY5U5WI";
    if (YoutubePlayer.convertUrlToId(url) != null &&
        YoutubePlayer.convertUrlToId(url).toString().isNotEmpty) {
      videoId = YoutubePlayer.convertUrlToId(url)!;
    } else {}

    _controller = YoutubePlayerController(
      initialVideoId: videoId == "" ? 'V7LwfY5U5WI' : videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    )..addListener(mk);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    ;
  }

  void mk() {
    if (_isPlayerReady && mounted) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        liveUIColor: Colors.amber,
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (_, player) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: player,
                ),
                Positioned(
                  top: 10,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
