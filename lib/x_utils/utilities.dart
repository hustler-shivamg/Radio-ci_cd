import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../x_res/my_res.dart';

/// Created by daewubintara on
/// 09, September 2020 11.03

///
/// --------------------------------------------
/// There are many amazing [Function]s in this class.
/// Especialy in [Function]ality.
/// You can find and use on your Controller wich is the Controller extends [BaseController].
class Utilities {
  void callPhoneNumber({String phone = "0"}) async {
    launch("tel://${phone}");
  }

  void intentOpenUrl({String link = "https://google.com"}) async {
    final url = link;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  launchMap({String lat = "47.6", String long = "-122.3"}) async {
    String googleUrl = Platform.isAndroid
        ? "google.navigation:q=$lat,$long&mode=d"
        : 'comgooglemaps://?q=$lat,$long&&directionsmode=driving';
    String appleUrl =
        'https://maps.apple.com/?saddr=Current%20Location&daddr=$lat,$long';
    if (!Platform.isAndroid && await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl1');
      await launch(googleUrl);
    } else if (Platform.isAndroid && await canLaunch(googleUrl)) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }

    // var mapSchema = 'geo:$lat,$long';
    // var uri = Uri.parse("google.navigation:q=$lat,$long&mode=d");
    // if (await canLaunch(uri.toString())) {
    //   await launch(uri.toString());
    // } else if (await canLaunch(mapSchema)) {
    //   await launch(mapSchema);
    // } else {
    //   print('Could not launch $uri');
    // }
  }

  shareContactDetails(
      {String? name, String? lname, String? address, String? phone}) {
    print(name);
    var shareData = "";
    if (name != null) {
      shareData = name + " " + (lname ?? "");
      shareData.trim();
    }

    if (address != null) {
      shareData += "\n" + address;
    }

    if (phone != null) {
      shareData += "\n" + phone;
    }

    if (shareData.isNotEmpty) {
      Share.share(shareData.trim());
    }
  }

  shareSongDetails({String? name, String? artist}) {
    print(name);
    var shareData = "";
    if (name != null) {
      shareData = name + " " + (artist ?? "");
      shareData.trim();
    }

    if (shareData.isNotEmpty) {
      Share.share(shareData.trim());
    }
  }

  int getAge(String birthDateString) {
    String datePattern = "yyyy-MM-dd";

    try {
      DateTime birthDate = DateFormat(datePattern, "en").parse(birthDateString);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      int month1 = currentDate.month;
      int month2 = birthDate.month;
      if (month2 > month1) {
        age--;
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          age--;
        }
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  String rupiahFormater(String value) {
    if (value == null || value == 'null') {
      value = "0";
    }

    double amount = double.parse(value);
    // FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    // String c = fmf.output.nonSymbol.toString().replaceAll(".00", "");
    // String fix = "Rp. " + c.replaceAll(",", ".");
    return value;
  }

  String moneyFormater(String value) {
    if (value == null || value == 'null') {
      value = "0";
    }

    double amount = double.parse(value);
    // FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    // String c = fmf.output.nonSymbol.toString().replaceAll(".00", "");
    // String fix = "" + c.replaceAll(",", ".");
    return value;
  }

  String formattedDate({String? format, String? date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date!);

    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  String formattedDateGetDay({required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('EEEE').format(dateTime);
    switch (formattedDate) {
      case "Monday":
        formattedDate = "Senin";
        break;
      case "Tuesday":
        formattedDate = "Selasa";
        break;
      case "Wednesday":
        formattedDate = "Rabu";
        break;
      case "Thursday":
        formattedDate = "Kamis";
        break;
      case "Friday":
        formattedDate = "Jum'at";
        break;
      case "Saturday":
        formattedDate = "Sabtu";
        break;
      case "Sunday":
        formattedDate = "Minggu";
        break;
    }

    return formattedDate;
  }

  String formattedDateGetMonth({required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('MMMM').format(dateTime);
    switch (formattedDate) {
      case "January":
        formattedDate = "Januari";
        break;
      case "February":
        formattedDate = "Februari";
        break;
      case "March":
        formattedDate = "Maret";
        break;
      case "April":
        formattedDate = "April";
        break;
      case "May":
        formattedDate = "Mei";
        break;
      case "June":
        formattedDate = "Juni";
        break;
      case "July":
        formattedDate = "Juli";
        break;
      case "August":
        formattedDate = "Agustus";
        break;
      case "September":
        formattedDate = "September";
        break;
      case "October":
        formattedDate = "Oktober";
        break;
      case "November":
        formattedDate = "November";
        break;
      case "December":
        formattedDate = "Desember";
        break;
    }

    return formattedDate;
  }

  String formattedSimpleDate({required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  }

  String formattedSuperSimpleDate(
      {required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('dd MMM').format(dateTime);
    return formattedDate;
  }

  String formattedDateTimeWithDay(
      {required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String day = formattedDateGetDay(format: format, date: date);

    String formattedDate = DateFormat('dd MMMM yyyy HH:mm').format(dateTime);
    return '${day}, ${formattedDate}';
  }

  String formattedDateTime({required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('dd MMMM yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  String formattedTime({required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return formattedDate;
  }

  String formattedSimpleDateTime(
      {required String format, required String date}) {
    if (date == 'null') {
      return "";
    }

    DateFormat dateFormat = DateFormat(format);
    DateTime dateTime = dateFormat.parse(date);

    String formattedDate = DateFormat('dd MMM yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  String parseHtmlString(String htmlString) {
    // var document = parse(htmlString);
    // String parsedString = parse(document.body.text).documentElement.text;
    return htmlString;
  }

  Future<String>? getVersionApp() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      if (Platform.isAndroid) {
        return "Version " + version;
      } else {
        return "Version " + version;
      }
    });
  }

  String stringCardFormated(
      {String value = "", int splitOn = 3, String modelSplit = " "}) {
    String newValue = "Error Formating";
    if (value.length < splitOn) {
      newValue = value;
    } else {
      int startIndex = 0;
      int endIndex = splitOn;
      newValue =
          _formating(startIndex, endIndex, value, "", splitOn, modelSplit);
    }
    return newValue;
  }

  String _formating(int startIndex, int endIndex, String value, String temp,
      int splitOn, String modelSplit) {
    if (startIndex == 0 && endIndex >= value.length) {
      temp = value.substring(startIndex, endIndex);
      return temp;
    }
    if (startIndex == 0 && endIndex < value.length) {
      temp = value.substring(startIndex, endIndex);
      startIndex += splitOn;
      endIndex += splitOn;
      return _formating(startIndex, endIndex, value, temp, splitOn, modelSplit);
    }
    if (startIndex < value.length && endIndex < value.length) {
      temp += "$modelSplit" + value.substring(startIndex, endIndex);
      startIndex += splitOn;
      endIndex += splitOn;
      return _formating(startIndex, endIndex, value, temp, splitOn, modelSplit);
    } else {
      temp += "$modelSplit" + value.substring(startIndex, value.length);
      return temp;
    }
  }

  Color? colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }
  }

  String? stringSliptedConvertToSentence(String string, String splitter) {
    string = string.replaceAll("$splitter", " ");
    string = string.capitalizeFirstofEach;
  }

  void logWhenDebug(String tag, String message) {
    if (kDebugMode)
      log("$tag => ${message.toString()}", name: MyConfig.APP_NAME);
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  String get allInCaps => this.toUpperCase();

  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.capitalize).join(" ");
}

extension on String? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
