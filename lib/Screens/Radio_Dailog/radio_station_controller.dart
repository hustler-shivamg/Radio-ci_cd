import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base/base_controller.dart';
import '../../models/radio_station_model.dart';
import '../Counter/counter_controller.dart';
import '../Playlist_screen/playlist_binding.dart';
import '../Videoprogram_screen/video_program_binding.dart';

class RadioStationController extends BaseController {
  List<RadioStationModel> radioList = [];
  RadioStationModel? selectedRadio;
  final CountDownTimerController countController = Get.find();

  @override
  void onInit() async {
    super.onInit();
    setScreenState = screenStateLoading;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await getRadioStationList();
  }

  Future getRadioStationList() async {
    var res = await getAllRadios();

    String text = '';

    if (res.isError!) text = XR().string.error_message;

    if (res.status == true) {
      try {
        radioList.clear();
        if (res.body != null) {
          res.body['result'].forEach((v) {
            radioList.add(RadioStationModel.fromJson(v));
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          int radioStationId = prefs.getInt(MyStrings.RADIOPREFID) ?? 0;
          print("radioStationId" + radioStationId.toString());
          if (radioStationId == 0) {
            selectedRadio = radioList[0];
          } else {
            for (RadioStationModel myRadio in radioList) {
              if (myRadio.idRadioStation == radioStationId) {
                selectedRadio = myRadio;
              } else {}
            }
          }

          PlaylistController _playlistController = Get.find();
          VideoProgramController _videoProgramController = Get.find();

          await _playlistController.getSongsForFirstTime();
          _playlistController.playRadioSongFromRadioStation();
          await _videoProgramController.getProgramsList();
        }
        refresh();
      } catch (e, s) {
        print(e);
        print(s);
        text = "Something went wrong here, try again later...";
        showSimpleErrorSnackBar(message: text);
      }
    } else {
      text = res.text!;
      showSimpleErrorSnackBar(message: text);
    }
    setScreenState = screenStateOk;
    refresh();
  }

  changeRadioDialog(BuildContext context) {
    return Get.dialog(
      SizedBox(
        height: 100,
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: radioList.length,
                    itemBuilder: (context, index) {
                      var item = radioList[index];
                      return InkWell(
                        onTap: () async {
                          if (selectedRadio != item) {
                            selectedRadio = item;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setInt(MyStrings.RADIOPREFID,
                                item.idRadioStation ?? 0);
                            PlaylistController _playlistController = Get.find();
                            VideoProgramController _videoProgramController =
                                Get.find();

                            _playlistController.getSongsForFirstTime();
                            _videoProgramController.getProgramsList();

                            _playlistController.playRadioSongFromRadioStation(
                                autoStart: true, reload: true);
                          }
                          Get.back();
                        },
                        child: Container(
                          color: selectedRadio!.idRadioStation ==
                                  item.idRadioStation
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.black,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 65.sp,
                                      width: 65.sp,
                                      margin: EdgeInsets.only(
                                        left: 28.w,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        child: CachedNetworkImage(
                                          imageUrl: item.radioStationLogo ?? "",
                                          height: 40.w,
                                          width: 40.w,
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Image.asset(
                                              "assets/app_icon.png",
                                              height: 40.w,
                                              width: 40.w,
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24.w,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Text(
                                        item.radioStationName ?? "Error",
                                        style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 27.h),
                                  child: Container(
                                    // height: 18.98.h,
                                    // width: 18.98.w,
                                    margin: EdgeInsets.only(right: 32.4.w),
                                    child: SvgPicture.asset(
                                      "assets/icons/play_sm.svg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r)),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h, bottom: 18.h),
                          child: RotationTransition(
                            turns: const AlwaysStoppedAnimation(180 / 360),
                            child: SvgPicture.asset(
                              "assets/icons/drop.svg",
                              height: 12.47.h,
                              width: 9.48.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
