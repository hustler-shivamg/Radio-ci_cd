import 'package:flutter/material.dart';

import '../../base/base_controller.dart';
import '../../models/video_programs_model.dart';
import '../Radio_Dailog/radio_station_controller.dart';

class VideoListingScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VideoListingScreenController());
  }
}

class VideoListingScreenController extends BaseController {
  List<VideoProgramModel> dataList = [];
  String programName = "";
  int ProgramId = -1;
  int currentPage = 1;
  int lastPage = 1;
  var scrollcontroller = ScrollController();
  bool isLoadingMore = false;
  final RadioStationController _dialogController = Get.find();

  @override
  void onInit() async {
    super.onInit();
    setScreenState = screenStateLoading;

    var args = Get.arguments;

    programName = args[0];
    ProgramId = args[1];

    getProviderList();

    print("programTitle $programName");
    print("programId $ProgramId");

    scrollcontroller.addListener(() async {
      if (scrollcontroller.position.pixels ==
          scrollcontroller.position.maxScrollExtent) {
        print("extra scroll");
        print("last page" + lastPage.toString());

        print("current page" + currentPage.toString());
        if (lastPage > currentPage && !isLoadingMore) {
          isLoadingMore = true;
          update();
          await getMoreSongsByPagination();
        }
      }
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future getProviderList() async {
    // var map = new Map<String, dynamic>();
    //
    // map["category_id"] = id;
    setScreenState = screenStateLoading;

    var map = Map<String, dynamic>();

    map["radioStationId"] =
        _dialogController.selectedRadio?.idRadioStation ?? 1;
    map["idPrograms"] = ProgramId;
    map['current_page'] = currentPage;

    var res = await getAllVideoPrograms(map);

    String text = '';

    if (res.isError!) {
      text = res.text ?? "something went wrong";
      showSimpleErrorSnackBar(message: text);
      text = XR().string.error_message;
    } else {
      if (res.status == true) {
        try {
          dataList.clear();
          res.body['result'].forEach((v) {
            print(v);
            dataList.add(VideoProgramModel.fromJson(v));
          });
          lastPage = res.body['last_page'];
          currentPage = res.body['current_page'];
          print("getProviderList last page is " + lastPage.toString());
        } catch (e, s) {
          print(s);
          print(e);

          text = "Something went wrong, try again later...";
          showSimpleErrorSnackBar(message: text);
        }
      } else {
        text = res.text!;
        showSimpleErrorSnackBar(message: text);
      }
    }
    setScreenState = screenStateOk;
    refresh();
    //showSnackBar(title: "Response", message: text);
  }

  Future getMoreSongsByPagination() async {
    print("more result called");
    var map = new Map<String, dynamic>();

    map["radioStationId"] =
        _dialogController.selectedRadio?.idRadioStation ?? 1;
    map["idPrograms"] = ProgramId;
    map['current_page'] = currentPage + 1;
    var res = await getAllVideoPrograms(map);

    String text = '';

    if (res.isError!) {
      text = res.text ?? "something went wrong";
      showSimpleErrorSnackBar(message: text);
      text = XR().string.error_message;
    } else {
      if (res.status == true) {
        lastPage = res.body['last_page'];
        currentPage = res.body['current_page'];
        try {
          res.body['result'].forEach((v) {
            dataList.add(VideoProgramModel.fromJson(v));
          });
          isLoadingMore = false;
          update();
        } catch (e, s) {
          text = "Something went wrong, try again later...";
          showSimpleErrorSnackBar(message: text);
          setScreenState = screenStateError;
        }
      } else {
        text = res.text ?? "something went wrong";
        showSimpleErrorSnackBar(message: text);
        setScreenState = screenStateError;
      }
    }
    isLoadingMore = false;
    refresh();
  }
}
