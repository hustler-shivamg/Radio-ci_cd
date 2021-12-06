import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

class CountDownTimerController extends GetxController {
  final start = 60.obs;
  final isStarted = false.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
  }

  void endTimer() {
    print("end called");
    isStarted.value = false;
    _timer.cancel();
  }

  void startTimer(int time) {
    start.value = time;
    isStarted.value = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          print("code to exit app");
          exit(0);
        } else {
          start.value--;
          print("count :" + start.value.toString());
        }
      },
    );
  }
}
