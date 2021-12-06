import 'package:flutter/cupertino.dart';

import '../../base/base_controller.dart';
import '../Counter/counter_controller.dart';
import '../Current_Screen/current_song.dart';
import '../Playlist_screen/playlist_binding.dart';
import '../Playlist_screen/playlist_screen.dart';
import '../Radio_Dailog/radio_station_controller.dart';
import '../Videoprogram_screen/video_program_binding.dart';
import '../Videoprogram_screen/video_programs_screen.dart';

class HomeScreennBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
    Get.lazyPut(() => PlaylistController());
    Get.lazyPut(() => VideoProgramController());
    Get.lazyPut(() => CountDownTimerController());
    Get.lazyPut(() => RadioStationController());
  }
}

class HomeScreenController extends BaseController {
  final Rx<int> tabIndex = 0.obs;
  final List<Widget> pageList = [
    CurrentSong(),
    PlaylistScreen(),
    VideoProgramsScreen(),
  ];

  void setPage(int index) {
    tabIndex(index);
  }

  @override
  void onInit() async {
    super.onInit();
    setScreenState = screenStateOk;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }
}
