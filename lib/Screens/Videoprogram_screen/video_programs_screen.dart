import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Counter/counter_controller.dart';
import '../Radio_Dailog/radio_station_controller.dart';
import 'video_program_binding.dart';
import '../widgets/timerwidget.dart';
import '../../base/base_controller.dart';
import '../../base/base_view_view_model.dart';
import '../Network_Error/network_error_page.dart';
import '../../duration_picker/duration_picker.dart';

import '../widgets/bottom_nav_widget.dart';

class VideoProgramsScreen extends BaseView<VideoProgramController> {
  final CountDownTimerController countController = Get.find();

  final RadioStationController dialogController = Get.find();

  VideoProgramsScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: controller.screenStateIsError ? NetworkErrorPage() : _body(context),
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
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 17.3.w, right: 29.w, top: 22.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(child: SizedBox()),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  dialogController.changeRadioDialog(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/Radiojan.svg",
                                      height: 54.11.h,
                                      width: 107.18.w,
                                    ),
                                    SvgPicture.asset(
                                      "assets/icons/drop.svg",
                                      height: 9.47.h,
                                      width: 5.48.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TimerWidget(),
                          ],
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
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 11.w,
                            mainAxisSpacing: 22.h,
                            childAspectRatio: 0.85,
                          ),
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 43.h,
                          ),
                          itemBuilder: (context, index) {
                            var item = controller.dataList[index];
                            return InkWell(
                              onTap: () {
                                var arguments = [
                                  item.programTitle,
                                  item.idPrograms,
                                ];

                                Get.toNamed(RouterName.videoListing,
                                    arguments: arguments);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 164.w,
                                    width: 164.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11.r),
                                      child: CachedNetworkImage(
                                        imageUrl: item.programImage,
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: Image.asset(
                                              "assets/app_icon.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    item.programTitle,
                                    maxLines: 1,
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          fontSize: 20.sp,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.white,
                                          letterSpacing: -1.sp),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: controller.dataList.length,
                          shrinkWrap: true,
                        ),
                ),
                SizedBox(
                  height: 60.h,
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
