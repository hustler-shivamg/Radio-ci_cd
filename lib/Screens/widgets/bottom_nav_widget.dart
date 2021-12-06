import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../x_routes/router_name.dart';
import '../Homepage/home_screen_binding.dart';
import '../Playlist_screen/playlist_binding.dart';
import '../Radio_Dailog/radio_station_controller.dart';

Widget bottomNavBar(BuildContext context) {
  final HomeScreenController homeScreenController = Get.find();
  final RadioStationController dialogController = Get.find();
  return Padding(
    padding: EdgeInsets.only(bottom: 30.h),
    child: Container(
      height: 68.h,
      width: 355.w,
      decoration: BoxDecoration(
          color: const Color(0xffAA3DD9).withOpacity(0.99),
          borderRadius: BorderRadius.circular(17.r)),
      margin: EdgeInsets.only(left: 18.w, right: 18.w),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () async {

                  final PlaylistController _playlistController = Get.find();
                  //_playlistController.isPlayingRadio = true;

                  if (_playlistController.pageController.page != 0) {
                    // await _playlistController.playRadioSongFromRadioStation(
                    //     autoStart: true);

                    _playlistController.pageController.jumpToPage(0);
                    _playlistController.update();
                  }
                  homeScreenController.setPage(0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/loop.svg",
                      height: 18.68.h,
                      width: 18.99.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Live",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'SF Compact',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {
                  homeScreenController.setPage(1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/p_list.svg",
                      height: 18.67.h,
                      width: 18.96.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Playlist",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'SF Compact',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {
                  homeScreenController.setPage(2);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/prog.svg",
                      height: 18.76.h,
                      width: 23.31.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Programs",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'SF Compact',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: Theme.of(context).primaryColorLight,
                onTap: () {
                  var parameters = <String, String>{
                    "yt_url": dialogController
                            .selectedRadio?.streams?.radioStationVideoURL ??
                        "",
                  };
                  Get.toNamed(RouterName.ytPlayer, parameters: parameters);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/mic.svg",
                      height: 18.93.h,
                      width: 18.53.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "Studio",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'SF Compact',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
