import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_radio_app/models/position_data.dart';
import 'package:rxdart/rxdart.dart' as RxDart;
import 'dart:math' as math; // import this

import '../../base/base_view_view_model.dart';
import '../../x_utils/perspective_pageview.dart';
import '../../x_utils/utilities.dart';
import '../Homepage/home_screen_binding.dart';
import '../Network_Error/network_error_page.dart';
import '../Playlist_screen/playlist_binding.dart';
import '../Radio_Dailog/radio_station_controller.dart';
import '../widgets/bottom_nav_widget.dart';
import '../widgets/timerwidget.dart';
import 'package:async/async.dart' show StreamGroup;

class CurrentSong extends BaseView<PlaylistController> {
  Color bottom = Colors.blue.shade700;
  Color top = Colors.red;

  //late AssetsAudioPlayer advancedPlayer;
  final RadioStationController dialogController = Get.find();
  List<String>? metadata;

  CurrentSong({Key? key}) : super(key: key);

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    //advancedPlayer.seek(newDuration);
  }

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: controller.screenStateIsError ? NetworkErrorPage() : _body(context),
    );
  }

  // Stream<PositionData> get _positionDataStream =>StreamGroup.merge<PositionData>([  controller.assetsAudioPlayer.positionStream,
  //   controller.assetsAudioPlayer.audioSource.downloadProgressStream,
  //   controller.assetsAudioPlayer.durationStream]);

  Stream<PositionData> get _positionDataStream =>
      RxDart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          controller.assetsAudioPlayer.positionStream,
          controller.assetsAudioPlayer.bufferedPositionStream,
          controller.assetsAudioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  _body(BuildContext context) {
    print("Loading INFO " +
        controller.isPlayingRadio.toString() +
        " " +
        (controller.isPlayingRadio
            ? controller.radioSongdata.songTitle
            : controller.currentSongdata.songTitle));

    final HomeScreenController homeScreenController = Get.find();
    return AnimatedContainer(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.15, 0.3, 0.8],
          colors: [top, Colors.purple, bottom],
        ),
      ),
      duration: const Duration(seconds: 2),
      child: Stack(
        children: [
          controller.screenStateIsLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 9.4.h, left: 28.w, right: 28.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset(
                                  "assets/icons/list.svg",
                                  height: 19.03.h,
                                  width: 18.2.w,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                dialogController.radioList.length > 1
                                    ? dialogController
                                        .changeRadioDialog(context)
                                    : print(
                                        "no more radio found to open the dialog");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/Radiojan.svg",
                                    height: 54.11.h,
                                    width: 107.18.w,
                                  ),
                                  dialogController.radioList.length > 1
                                      ? SvgPicture.asset(
                                          "assets/icons/drop.svg",
                                          height: 9.47.h,
                                          width: 5.48.w,
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                          TimerWidget()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.4.h,
                    ),
                    SizedBox(
                      height: 266.23.h,
                      // color: Colors.transparent.withOpacity(0.5),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: controller.isPlayingRadio,
                            child: PerspectivePageView(
                              attachScroll: false,
                              mKey: "radioList",
                              hasShadow: false,
                              shadowColor: Colors.transparent,
                              aspectRatio: PVAspectRatio.SIXTEEN_NINE,
                              children: [controller.radioSongdata]
                                  .map(
                                    (e) => ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: e.songImage,
                                            width: 266.23.w,
                                            height: 266.23.h,
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Image.asset(
                                                "assets/app_icon.png",
                                                width: 266.23.w,
                                                height: 266.23.h,
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Visibility(
                            visible: !controller.isPlayingRadio,
                            child: PerspectivePageView(
                              mKey: "two",
                              attachScroll: true,
                              hasShadow: false,
                              shadowColor: Colors.transparent,
                              aspectRatio: PVAspectRatio.SIXTEEN_NINE,
                              children: controller.dataList
                                  .map((e) => ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Stack(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: e.songImage,
                                            width: 266.23.w,
                                            height: 266.23.h,
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Image.asset(
                                                "assets/app_icon.png",
                                                width: 266.23.w,
                                                height: 266.23.h,
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10.h,
                                            right: 10.w,
                                            child: InkWell(
                                              onTap: () async {
                                                await controller
                                                    .likeSong(e.idSong,false);
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/dislike_icon.svg",
                                                height: 22.h,
                                                width: 22.h,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10.h,
                                            left: 10.w,
                                            child: InkWell(
                                              onTap: () async {
                                                await controller
                                                    .likeSong(e.idSong,true);
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/like_icon.svg",
                                                height: 22.h,
                                                color: Colors.white,

                                                width: 22.h,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Text(
                      controller.isPlayingRadio
                          ? controller.radioSongdata.songTitle
                          : controller.currentSongdata.songTitle,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 27.sp,
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        controller.isPlayingRadio
                            ? controller.radioSongdata.songArtist
                            : controller.currentSongdata.songArtist,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 17.sp,
                            color: const Color(0xff707070),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 31.w, right: 31.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.white.withOpacity(0.0),
                            child: Center(
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                splashColor:
                                    Theme.of(context).primaryColorLight,
                                onTap: () {
                                  homeScreenController.setPage(1);
                                },
                                child: SvgPicture.asset(
                                    "assets/icons/music.svg",
                                    height: 23.64.h,
                                    width: 23.99.w),
                              ),
                            ),
                          ),
                          StreamBuilder<PlayerState>(
                            stream:
                                controller.assetsAudioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              var playerState = snapshot.data;

                              final isPlaying = playerState?.playing;
                              final processingState =
                                  playerState?.processingState;
                              if (processingState == ProcessingState.loading ||
                                  processingState ==
                                      ProcessingState.buffering) {
                                return Center(
                                  child: SizedBox(
                                    child: const CircularProgressIndicator(),
                                    height: 49.h,
                                    width: 49.w,
                                  ),
                                );
                              } else if (!(isPlaying ?? false)) {
                                return InkWell(
                                  onTap: () async {
                                    await controller.assetsAudioPlayer.play();
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/play.svg",
                                    height: 49.h,
                                    width: 49.w,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return InkWell(
                                  onTap: () async {
                                    await controller.assetsAudioPlayer.pause();
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/pause.svg",
                                    height: 49.h,
                                    width: 49.w,
                                    color: Colors.white,
                                  ),
                                );
                              }

                              // if (snapshot.data?.isBuffering ?? false) {
                              //   //Buffering
                              //   return Center(
                              //     child: SizedBox(
                              //       child: const CircularProgressIndicator(),
                              //       height: 49.h,
                              //       width: 49.w,
                              //     ),
                              //   );
                              // } else if (snapshot.data?.isPlaying ?? false) {
                              //   //Playing
                              //   return InkWell(
                              //     onTap: () async {
                              //       await controller.assetsAudioPlayer.pause();
                              //     },
                              //     child: SvgPicture.asset(
                              //       "assets/icons/pause.svg",
                              //       height: 49.h,
                              //       width: 49.w,
                              //       color: Colors.white,
                              //     ),
                              //   );
                              // } else {
                              //   //Stopped
                              //   return InkWell(
                              //     onTap: () async {
                              //       await controller.assetsAudioPlayer.play();
                              //     },
                              //     child: SvgPicture.asset(
                              //       "assets/icons/play.svg",
                              //       height: 49.h,
                              //       width: 49.w,
                              //       color: Colors.white,
                              //     ),
                              //   );
                              // }
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Utilities().shareSongDetails(
                                name: controller.currentSongdata.songTitle,
                                artist: controller.currentSongdata.songArtist,
                              );
                            },
                            child: SvgPicture.asset(
                              "assets/icons/share.svg",
                              height: 32.15.h,
                              width: 26.9.w,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 35.w, right: 35.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/vol.svg",
                            height: 16.44.h,
                            width: 21.06.w,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: StreamBuilder<PositionData>(
                              stream: _positionDataStream,
                              builder: (context, snapshot) {
                                // print("<<<<< NEW_STATE >>>>>>>");
                                // print("NEW_STATE ${snapshot.data?.duration}");
                                // print("NEW_STATE ${snapshot.data?.position}");
                                // if (snapshot.data?.isBuffering ?? false) {
                                //   print(
                                //       "<<<<<<<<<<<<<<<<<<<<<< BUFFERING >>>>>>>>>>>>>>>>>>>>>>");
                                // } else if (snapshot.data?.isPlaying ?? false) {
                                //   print(
                                //       "<<<<<<<<<<<<<<<<<<<<<< PLAYING >>>>>>>>>>>>>>>>>>>>>>");
                                // } else {
                                //   print(
                                //       "<<<<<<<<<<<<<<<<<<<<<< STOPPED/NO STATE >>>>>>>>>>>>>>>>>>>>>>");
                                // }

                                return snapshot.data?.duration != null &&
                                        snapshot.data?.duration != Duration.zero
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        child: ProgressBar(
                                          baseBarColor:
                                              Colors.white.withOpacity(0.3),
                                          thumbGlowRadius: 15,
                                          barHeight: 2,
                                          bufferedBarColor: Colors.white,
                                          progressBarColor: Colors.white,
                                          thumbGlowColor: Colors.white,
                                          thumbColor: Colors.white,
                                          onDragEnd: () {
                                            print(
                                                "INN ${snapshot.data?.duration}");
                                            print(
                                                "INN ${snapshot.data?.position}");
                                            if (snapshot.data == null ||
                                                snapshot.data?.duration ==
                                                    Duration.zero) {
                                              print("INN");
                                              controller.refresh();
                                            }
                                          },
                                          progress: snapshot.data?.position ??
                                              Duration.zero,
                                          total: snapshot.data?.duration ??
                                              Duration.zero,
                                          buffered:
                                              snapshot.data?.bufferedPosition ??
                                                  Duration.zero,
                                          // onSeek: ,
                                          timeLabelLocation:
                                              TimeLabelLocation.none,
                                          onSeek: (value) {
                                            if (snapshot.data?.duration !=
                                                Duration.zero) {
                                              controller.assetsAudioPlayer
                                                  .seek(value);
                                            }
                                          },
                                        ),
                                      )
                                    : IgnorePointer(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: ProgressBar(
                                            baseBarColor:
                                                Colors.white.withOpacity(0.3),
                                            thumbGlowRadius: 15,
                                            barHeight: 2,
                                            bufferedBarColor: Colors.white,
                                            progressBarColor: Colors.white,
                                            thumbGlowColor: Colors.white,
                                            thumbColor: Colors.white,
                                            progress: Duration(seconds: 0),
                                            total: Duration(seconds: 0),
                                            // onSeek: ,
                                            timeLabelLocation:
                                                TimeLabelLocation.none,
                                            onSeek: (duration) {
                                              // controller.seekToSecond(
                                              //     duration.inMilliseconds);
                                            },
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/icons/loop.svg",
                            height: 18.68.h,
                            width: 18.99.w,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      height: 141.h,
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/icons/adv.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 112.h,
                    ),
                  ],
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomNavBar(context),
          ),
        ],
      ),
    );
  }
}
