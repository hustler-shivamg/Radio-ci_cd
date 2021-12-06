import '../base/networking/api.dart';
import '../base/networking/result.dart';

/// createdby Daewu Bintara
/// Friday, 1/29/21

///
/// --------------------------------------------
/// In this class where the [Function]s correspond to the API.
/// Which function here you will make it and you will consume it.
/// You can find and use on your Controller wich is the Controller extends [BaseController].
class Repositories {
  final ApiService _service = ApiService();

  // Future<Result> getAllSongs() async =>
  //     await _service.getData(endPoint: "radio");
  Future<Result> getAllSongs(Map? data) async =>
      await _service.postData(endPoint: "audio-playlist",data: data);

  Future<Result> getAllAlbums(Map? data)  async =>
      await _service.postData(endPoint: "programs",data: data);

  Future<Result> getAllVideoPrograms(Map? data) async =>
      await _service.postData(endPoint: "programs-playlist", data: data);

  Future<Result> getAllRadios() async =>
      await _service.postData(endPoint: "radio-station");


  Future<Result> songRating(Map? data) async =>
      await _service.postData(endPoint: "song-like-dislike", data: data, withToken: false);

  //
  // Future<Result> deleteReview(Map? data) async => await _service.postData(
  //     endPoint: "delete-review", data: data, withToken: true);
  //
  // Future<Result> resetPassword(Map? data) async => await _service.postData(
  //     endPoint: "forget-password", data: data, withToken: false);
  //
  // Future<Result> forgotPassword(Map? data) async =>
  //     await _service.postData(endPoint: "reset", data: data, withToken: false);
  //
  // Future<Result> getCategories() async =>
  //     await _service.getData(endPoint: "categories");
  //
  // Future<Result> getFav() async =>
  //     await _service.getData(endPoint: "list-of-favourite");
  //
  // Future<Result> getMyReviews() async =>
  //     await _service.getData(endPoint: "list-of-review");
  //
  // Future<Result> getProviders(Map? data) async =>
  //     await _service.postData(endPoint: "get-providers", data: data);
  //
  // Future<Result> getBusinessProviders(String? id) async =>
  //     await _service.getData(endPoint: "sub-categories/$id");
  //
  // Future<Result> sendOTP(Map? data) async => await _service.postData(
  //     endPoint: "send-otp", withToken: false, data: data);
  //
  // Future<Result> updateProfile(Map? data) async => await _service.postData(
  //     endPoint: "update-user-details", withToken: true, data: data);
  //
  // Future<Result> doRegister(dynamic? data) async => await _service.postData(
  //     endPoint: "register", withToken: false, data: data);
  //
  // Future<Result> checkOTP(dynamic? data) async => await _service.postData(
  //     endPoint: "check-otp", withToken: false, data: data);
  //
  // Future<Result> doCaregiverRegister(dynamic? data) async =>
  //     await _service.postData(
  //         endPoint: "become-service-provider", withToken: true, data: data);
  //
  // Future<Result> getProviderDetails(Map? data) async =>
  //     await _service.postData(endPoint: "get-details", data: data);
  //
  // Future<Result> addToFav(Map? data) async =>
  //     await _service.postData(endPoint: "add-to-favourite", data: data);
  //
  // Future<Result> addMyReview(Map? data) async =>
  //     await _service.postData(endPoint: "add-review", data: data);
  //
  // Future<Result> editMyReview(Map? data) async => await _service.postData(
  //     endPoint: "edit-review", data: data, withToken: true);
  //
  // Future<Result> getAllDropDowns() async =>
  //     await _service.getData(endPoint: "drop-down");

  // Future<Result> registerServiceProvider(Map? data) async =>
  //     await _service.postData(endPoint: "add-review", data: data);
  //

}
