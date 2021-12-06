import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_radio_app/Screens/Counter/counter_controller.dart';
import 'package:my_radio_app/Screens/Homepage/home_screen_binding.dart';
import 'package:my_radio_app/Screens/Network_Error/network_error_page.dart';
import 'package:my_radio_app/Screens/Playlist_screen/playlist_binding.dart';
import 'package:my_radio_app/Screens/Radio_Dailog/radio_station_controller.dart';
import 'package:my_radio_app/Screens/widgets/timerwidget.dart';
import 'package:my_radio_app/base/base_view_view_model.dart';
import 'package:my_radio_app/duration_picker/duration_picker.dart';
import 'package:my_radio_app/models/position_data.dart';

import '../widgets/bottom_nav_widget.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart' as RxDart;

enum PlayerState { stopped, playing, paused }

class PlaylistScreen extends BaseView<PlaylistController> {
  final CountDownTimerController countController = Get.find();
  final RadioStationController dialogController = Get.find();

  PlaylistScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: controller.screenStateIsError ? NetworkErrorPage() : _body(context),
    );
  }

  Stream<PositionData> get _positionDataStream =>
      RxDart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          controller.assetsAudioPlayer.positionStream,
          controller.assetsAudioPlayer.bufferedPositionStream,
          controller.assetsAudioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  _body(BuildContext context) {
    final HomeScreenController homeScreenController = Get.find();
    if (controller.screenStateIsError) return Text(XR().string.error_message);
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.1, 0.3, 0.8],
        colors: [Color(0xFF8F0000), Color(0xFF7A007A), Color(0xFF00003D)],
      )),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.3, 0.5, 0.8],
                    colors: [
                      Color(0xFF800A0A),
                      Color(0xFF6A0B6A),
                      Color(0xFF0F0F65)
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 28.w, top: 45.h, right: 28.w, bottom: 14.h),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "PLAYLIST",
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TimerWidget(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 13.w, right: 13.w, bottom: 12.h),
                      child: Container(
                        width: 365.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0x40000000),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextFormField(
                            style: TextStyle(
                              color: const Color(0xffFFFFFF),
                              fontSize: 20.sp,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 20.w),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                  top: 13.7.h,
                                  bottom: 13.7.h,
                                ),
                                child: SizedBox(
                                  height: 17.68.h,
                                  width: 17.51.w,
                                  child: SvgPicture.asset(
                                    "assets/icons/search.svg",
                                  ),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              value.isEmpty
                                  ? controller.seaching.value = false
                                  : controller.seaching.value = true;
                              if (controller.dataList.isNotEmpty) {
                                controller.searchlist.clear();
                                for (var element in controller.dataList) {
                                  element.songTitle
                                          .toLowerCase()
                                          .contains(value.toLowerCase())
                                      ? controller.searchlist.add(element)
                                      : null;
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.screenStateIsLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Obx(
                        () {
                          return !controller.seaching.value
                              ? ListView.builder(
                                  controller: controller.scrollcontroller,
                                  itemCount: controller.dataList.length,
                                  padding: EdgeInsets.only(bottom: 100.h),
                                  itemBuilder: (context, index) {
                                    var item = controller.dataList[index];
                                    bool isValidSong = controller
                                        .dataList[index]
                                        .songAudioUrl
                                        .isNotEmpty;
                                    String formattedDate = "";
                                    try {
                                      final dateTime = DateTime.parse(
                                          item.createdAt.toString());
                                      final format = DateFormat('MM/dd/yyyy');
                                      formattedDate = format.format(dateTime);
                                    } catch (e) {
                                      print("error $e");
                                    }
                                    final duration =
                                        item.songDuration.isNotEmpty
                                            ? parseDuration(item.songDuration)
                                            : const Duration(seconds: 0);
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (controller
                                                    .currentSongdata.idBroadcasted ==
                                                item.idBroadcasted) {
                                              homeScreenController.setPage(0);
                                            } else if (isValidSong) {
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 50));
                                              print("Song List Url : " +
                                                  controller.dataList[index]
                                                      .songAudioUrl
                                                      .toString());
                                              print("Tried to jump to $index");

                                              await controller.playNewSong(
                                                  controller.dataList[index],
                                                  autoStart: false);

                                              WidgetsBinding.instance
                                                  ?.addPostFrameCallback(
                                                (_) {
                                                  homeScreenController
                                                      .setPage(0);
                                                  controller.pageController
                                                      .jumpToPage(index);
                                                },
                                              );
                                            }
                                          },
                                          child: SizedBox(
                                            height: 85.5.h,
                                            // margin: EdgeInsets.only(top: 35.h),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 13.5.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 65.h,
                                                        width: 60.w,
                                                        margin: EdgeInsets.only(
                                                          left: 28.w,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.r),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                item.songImage,
                                                            alignment: Alignment
                                                                .center,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Center(
                                                              child: Image.asset(
                                                                  "assets/app_icon.png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 24.w,
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.h),
                                                        width: 220.w,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item.songTitle,
                                                              maxLines: 1,
                                                              style: GoogleFonts.montserrat(
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          18.sp,
                                                                      color: Colors
                                                                          .white,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            Text(
                                                              item.songArtist,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5),
                                                                  letterSpacing:
                                                                      1.4.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  formattedDate
                                                                      .toString(),
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11.sp,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                      letterSpacing:
                                                                          1.1.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 20.w,
                                                                ),
                                                                StreamBuilder<
                                                                    PositionData>(
                                                                  stream:
                                                                      _positionDataStream,
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (controller
                                                                            .currentSongdata
                                                                            .idBroadcasted ==
                                                                        item.idBroadcasted) {
                                                                      if (snapshot.data?.duration !=
                                                                              null &&
                                                                          snapshot.data?.duration !=
                                                                              Duration.zero) {
                                                                        Duration
                                                                            totalDuration =
                                                                            snapshot.data?.duration ??
                                                                                const Duration(seconds: 0);

                                                                        Duration
                                                                            currentDuration =
                                                                            snapshot.data?.position ??
                                                                                Duration.zero;

                                                                        var remainingDuration =
                                                                            Duration(seconds: totalDuration.inSeconds - currentDuration.inSeconds);

                                                                        return Text(
                                                                          remainingDuration.inMinutes.remainder(60).toString().padLeft(2, '0') +
                                                                              ":" +
                                                                              remainingDuration.inSeconds.remainder(60).toString().padLeft(2, '0'),
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 11.sp,
                                                                              color: Colors.white.withOpacity(0.5),
                                                                              letterSpacing: 1.1.sp,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Text(
                                                                          duration.inMinutes.toString().padLeft(2, '0') +
                                                                              ":" +
                                                                              duration.inSeconds.toString().padLeft(2, '0'),
                                                                          style:
                                                                              GoogleFonts.montserrat(
                                                                            textStyle:
                                                                                TextStyle(
                                                                              fontSize: 11.sp,
                                                                              color: Colors.white.withOpacity(0.5),
                                                                              letterSpacing: 1.1.sp,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                    } else {
                                                                      return Text(
                                                                        duration.inMinutes.toString().padLeft(2,
                                                                                '0') +
                                                                            ":" +
                                                                            duration.inSeconds.toString().padLeft(2,
                                                                                '0'),
                                                                        style: GoogleFonts
                                                                            .montserrat(
                                                                          textStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11.sp,
                                                                            color:
                                                                                Colors.white.withOpacity(0.5),
                                                                            letterSpacing:
                                                                                1.1.sp,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: 20.w,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  isValidSong
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16.h),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      32.4.w),
                                                          child: StreamBuilder<
                                                              PositionData>(
                                                            stream:
                                                                _positionDataStream,
                                                            builder: (context,
                                                                snapshot) {
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    controller.currentSongdata.idBroadcasted ==
                                                                                item.idBroadcasted &&
                                                                            controller.assetsAudioPlayer.playing
                                                                        ? "assets/icons/pause.svg"
                                                                        : "assets/icons/play.svg",
                                                                    height:
                                                                        22.h,
                                                                    width: 22.w,
                                                                    color: Colors
                                                                        .white,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  controller.currentSongdata.idBroadcasted ==
                                                                              item
                                                                                  .idBroadcasted &&
                                                                      controller.assetsAudioPlayer.playing
                                                                      ? Image(
                                                                          height:
                                                                              12.w,
                                                                          width:
                                                                              12.w,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              const AssetImage(
                                                                            "assets/icons/equ_play.gif",
                                                                          ),
                                                                        )
                                                                      : const SizedBox
                                                                          .shrink(),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        controller.dataList.length - 1 == index
                                            ? controller.isLoadingMore
                                                ? SizedBox(
                                                    height: 25.w,
                                                    width: 25.w,
                                                    child: const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ))
                                                : const SizedBox.shrink()
                                            : const SizedBox.shrink(),
                                        Divider(
                                            color:
                                                Colors.white.withOpacity(0.3)),
                                      ],
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: controller.searchlist.length,
                                  itemBuilder: (context, index) {
                                    var item = controller.searchlist[index];
                                    bool isValidSong = controller
                                        .dataList[index]
                                        .songAudioUrl
                                        .isNotEmpty;
                                    print("leng" +
                                        controller.searchlist.length
                                            .toString());
                                    final dateTime = DateTime.parse(
                                        item.createdAt.toString());
                                    final format = DateFormat('MM/dd/yyyy');
                                    final formattedDate =
                                        format.format(dateTime);
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (controller
                                                    .currentSongdata.idBroadcasted ==
                                                item.idBroadcasted) {
                                              homeScreenController.setPage(0);
                                            } else if (isValidSong) {
                                              print("search Song List Url : " +
                                                  controller.searchlist[index]
                                                      .songAudioUrl
                                                      .toString());

                                              controller.playNewSong(
                                                  controller.searchlist[index]);
                                              int fakeid = controller.dataList
                                                  .indexWhere((element) =>
                                                      element.idBroadcasted.isEqual(
                                                          item.idBroadcasted));
                                              controller.pageController
                                                  .jumpToPage(fakeid);
                                              homeScreenController.setPage(0);
                                            }
                                          },
                                          child: SizedBox(
                                            height: 85.5.h,
                                            // margin: EdgeInsets.only(top: 35.h),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 13.5.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 65.h,
                                                        width: 65.w,
                                                        margin: EdgeInsets.only(
                                                          left: 28.w,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.r),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                item.songImage,
                                                            alignment: Alignment
                                                                .center,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Center(
                                                              child: Image.asset(
                                                                  "assets/app_icon.png"),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 24.w,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              item.songTitle,
                                                              style: GoogleFonts.montserrat(
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          18.sp,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            Text(
                                                              item.songArtist,
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  formattedDate,
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11.sp,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  isValidSong
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 27.h),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              await controller
                                                                  .playNewSong(
                                                                      controller
                                                                              .searchlist[
                                                                          index]);
                                                              controller
                                                                  .pageController
                                                                  .jumpToPage(
                                                                      index);
                                                            },
                                                            child: Container(
                                                              // height: 18.98.h,
                                                              // width: 18.98.w,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 32.4
                                                                          .w),
                                                              child: SvgPicture
                                                                  .asset(
                                                                controller.currentSongdata.idBroadcasted ==
                                                                            item
                                                                                .idBroadcasted &&
                                                                        controller
                                                                            .isPlaying
                                                                    ? "assets/icons/pause.svg"
                                                                    : "assets/icons/play.svg",
                                                                height: 22.h,
                                                                width: 22.w,
                                                                color: Colors
                                                                    .white,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ],
                                    );
                                  },
                                );
                        },
                      ),
              )
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

  Future<void> openTimePicker(context) async {
    var resultingDuration = await showDurationPicker(
      context: context,
      initialTime: const Duration(minutes: 30),
    );
    if (resultingDuration != null) {
      countController.startTimer(resultingDuration.inSeconds);
      print("result " + resultingDuration.toString());
    }
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros = 0;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1])).round();
    return Duration(hours: hours, minutes: minutes, seconds: micros);
  }
}
