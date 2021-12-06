import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../base/base_view_view_model.dart';
import '../../duration_picker/duration_picker.dart';
import '../../x_routes/router_name.dart';
import '../Counter/counter_controller.dart';
import '../widgets/timerwidget.dart';
import 'videolisting_binding.dart';

class VideoListingScreen extends BaseView<VideoListingScreenController> {
  final CountDownTimerController countController = Get.find();

  VideoListingScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    if (controller.screenStateIsError) {
      return Text(XR().string.error_message);
    } else {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.3, 0.8],
            colors: [Color(0xFF8F0000), Color(0xFF7A007A), Color(0xFF00003D)],
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 109.h,
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
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 17.3.w, right: 31.w, top: 34.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/back.svg",
                            height: 20.3.h,
                            width: 11.75.w,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: Text(
                            "Video List",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        TimerWidget(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 28.w),
                  child: Text(
                    controller.screenStateIsLoading
                        ? ""
                        : controller.programName,
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Expanded(
                  child: controller.screenStateIsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.dataList.isEmpty
                          ? Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.sp),
                              ),
                            )
                          : ListView.builder(
                              controller: controller.scrollcontroller,
                              itemCount: controller.dataList.length,
                              itemBuilder: (context, index) {
                                var item = controller.dataList[index];

                                final dateTime =
                                    DateTime.parse(item.createdAt.toString());
                                final format = DateFormat('EEEE dd, yyyy');
                                final clockString = format.format(dateTime);

                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (item.youTubeUrl.isNotEmpty &&
                                            item.youTubeUrl != null) {
                                          print("yt url" + item.youTubeUrl);
                                          var parameters = <String, String>{
                                            "yt_url": item.youTubeUrl,
                                          };
                                          Get.toNamed(RouterName.ytPlayer,
                                              parameters: parameters);
                                        } else {
                                          print("url" + item.videoUrl);
                                          var parameters = <String, String>{
                                            "video_url": item.videoUrl,
                                          };
                                          Get.toNamed(RouterName.videoPlayer,
                                              parameters: parameters);
                                        }
                                      },
                                      child: SizedBox(
                                        height: 90.h,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 65.h,
                                                    width: 113.w,
                                                    margin: EdgeInsets.only(
                                                      left: 30.w,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.r),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            item.videoThumbnail,
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Center(
                                                          child: Image.asset(
                                                            "assets/app_icon.png",
                                                            height: 65.h,
                                                            width: 113.w,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 17.w,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 170.w,
                                                          child: Text(
                                                            item.videoTitle,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: false,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          clockString,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.sp,
                                                              letterSpacing:
                                                                  1.4.sp,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "06:55",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 11.sp,
                                                              letterSpacing:
                                                                  1.1.sp,
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Center(
                                                child: Container(
                                                  height: 20.98.h,
                                                  width: 20.98.w,
                                                  margin: EdgeInsets.only(
                                                      right: 30.4.w),
                                                  child: SvgPicture.asset(
                                                    "assets/icons/play.svg",
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
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
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ],
                                );
                              },
                            ),
                ),
              ],
            ),
          ],
        ),
      );
    }
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
}
