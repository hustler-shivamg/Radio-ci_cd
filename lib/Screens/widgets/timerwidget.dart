import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../Counter/counter_controller.dart';
import '../../duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerWidget extends StatelessWidget {
  final CountDownTimerController countController = Get.find();

  TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!countController.isStarted.value) {
          return Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.34,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    openTimePicker(context);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/timer.svg",
                    height: 18.98.h,
                    width: 18.98.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.34,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    countController.endTimer();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/red_timer.svg",
                        height: 29.h,
                        width: 29.w,
                        fit: BoxFit.cover,
                      ),
                      buildTextForTimer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildTextForTimer() {
    if (countController.start.value < 60) {
      return Text(
        ((countController.start.value).toInt()).toString() + " s",
        style: TextStyle(
          fontSize: 10.sp,
          color: const Color(0xffFFFFFF),
        ),
      );
    } else if ((countController.start.value / 60) > 60) {
      return Text(
        ((countController.start.value / 60) ~/ 60).toString() +
            " h " +
            (((countController.start.value / 60) % 60).toInt().toString()) +
            " m",
        style: TextStyle(
          fontSize: 10.sp,
          color: const Color(0xffFFFFFF),
        ),
      );
    } else {
      return Text(
        (countController.start.value ~/ 60).toString() + " m",
        style: TextStyle(
          fontSize: 10.sp,
          color: const Color(0xffFFFFFF),
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
