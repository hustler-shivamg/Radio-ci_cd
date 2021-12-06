import '../Radio_Dailog/radio_station_controller.dart';
import '../../base/base_controller.dart';
import '../../models/album_model.dart';

class VideoProgramScreenBinding implements Bindings {
  @override
  void dependencies() {}
}

class VideoProgramController extends BaseController {
  List<AlbumModel> dataList = [];
  final RadioStationController _dialogController = Get.find();

  Future getProgramsList() async {
    setScreenState = screenStateLoading;
    update();

    var map = Map<String, dynamic>();

    map["radioStationId"] =
        _dialogController.selectedRadio?.idRadioStation ?? 1;
    var res = await getAllAlbums(map);

    String text = '';

    if (res.isError!) text = XR().string.error_message;

    if (res.status == true) {
      try {
        dataList.clear();
        res.body['result']['data'].forEach((v) {
          dataList.add(AlbumModel.fromJson(v));
        });
      } catch (e, s) {
        print(s);
        text = "Something went wrong, try again later...";
        showSimpleErrorSnackBar(message: text);
      }
    } else {
      text = res.text!;
      showSimpleErrorSnackBar(message: text);
    }
    setScreenState = screenStateOk;
    refresh();
  }
}
