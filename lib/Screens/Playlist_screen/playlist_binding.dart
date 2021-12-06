import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import '../Radio_Dailog/radio_station_controller.dart';
import '../../base/base_controller.dart';
import '../../models/song_model.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class PlaylistScreenBinding implements Bindings {
  @override
  void dependencies() {}
}

class PlaylistController extends BaseController {
  List<SongModel> dataList = [];
  PageController pageController = PageController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currentPage = 1;
  int lastPage = 1;
  var scrollcontroller = ScrollController();
  bool isLoadingMore = false;
  bool isPlayingRadio = false;
  final RadioStationController _radioStationController = Get.find();
  Duration leftDuration = const Duration(seconds: 1);
  Duration totalDuration = const Duration(seconds: 1);
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  CollectionReference? radio1Collection;
  SongModel currentSongdata = SongModel(
      idSong: 1,
      idRadioStation: 1,
      songTitle: "",
      songArtist: "",
      songAlbum: "",
      songGenre: "",
      songImage: "",
      songAudioUrl: "",
      songYouTubeUrl: "",
      songVideoUrl: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      songDuration: '');

  SongModel radioSongdata = SongModel(
      idSong: -1,
      idRadioStation: -1,
      songTitle: "",
      songArtist: "",
      songAlbum: "",
      songGenre: "",
      songImage: "",
      songAudioUrl: "",
      songYouTubeUrl: "",
      songVideoUrl: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      songDuration: '');

//  final _player = AudioPlayer();

  AudioPlayer assetsAudioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isAudio = false;
  PlayerState? playerState;
  final searchlist = <SongModel>[].obs;
  RxBool seaching = false.obs;

//  var data;

  @override
  void onInit() async {
    super.onInit();
    setScreenState = screenStateLoading;

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    // Listen to errors during playback.
    assetsAudioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    // assetsAudioPlayer.isPlaying.listen((event) {
    //   isPlaying = event;
    //   refresh();
    // });
    // assetsAudioPlayer.onErrorDo = (errorHandler) {
    //   print("On Radio Error "+errorHandler.error.message);
    //   assetsAudioPlayer.stop();
    // };
    //

    // assetsAudioPlayer.playlistAudioFinished.listen((Playing playing) {
    //   print("called when finished");
    //   int myindex = dataList
    //       .indexWhere((element) => element.idSong == currentSongdata.idSong);
    //   playNewSong(dataList[myindex + 1]);
    //   pageController.animateToPage(myindex + 1,
    //       duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    // });

    scrollcontroller.addListener(() async {
      if (scrollcontroller.position.pixels ==
          scrollcontroller.position.maxScrollExtent) {
        print("last page" + lastPage.toString());
        print("current page" + currentPage.toString());
        if (lastPage > currentPage && !isLoadingMore) {
          isLoadingMore = true;
          update();
          await getMoreSongsByPagination();
        }
      }
    });

    assetsAudioPlayer.playerStateStream.listen((state) {
      print(
          "<<<<<<<<<<<<< ${state.processingState} ${state.playing}>>>>>>>>>>>>>>>");

      switch (state.processingState) {
        case ProcessingState.idle:
          break;
        case ProcessingState.loading:
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          if (state.playing) {
            Future.delayed(Duration(seconds: 1), playNextSongFromList());
          }
          //playNextSongFromList();
          break;
      }
    });
  }

  getMoreSongOnSliderChange() async {
    if (lastPage > currentPage && !isLoadingMore) {
      isLoadingMore = true;
      update();
      await getMoreSongsByPagination();
    }
  }

  playNextSongFromList() {
    var currentPos = -1;
    currentPos = dataList.indexOf(currentSongdata);

    if (dataList.length > currentPos) {
      pageController.nextPage(
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }

  // playRadioSongFromRadioStation2(
  //     {bool autoStart = false, bool reload = false}) async {
  //   print("isPlayingRadio $isPlayingRadio");
  //   print("reload $reload");
  //
  //   if (!isPlayingRadio || reload) {
  //     isPlayingRadio = true;
  //     currentPage = 1;
  //     lastPage = 1;
  //
  //     var selectedRadio = _radioStationController.selectedRadio;
  //     radioSongdata = SongModel(
  //         idSong: 0,
  //         idRadioStation: selectedRadio?.idRadioStation ?? 1,
  //         songTitle: selectedRadio?.radioStationName ?? "Radio",
  //         songArtist: selectedRadio?.radioStationAddress ?? "",
  //         songAlbum: selectedRadio?.radioStationSlogan ?? "",
  //         songGenre: selectedRadio?.radioStationName ?? "",
  //         songImage: selectedRadio?.radioStationLogo ?? "",
  //         songAudioUrl: selectedRadio?.streams?.radioStationAudioURL ?? "",
  //         songYouTubeUrl: selectedRadio?.streams?.radioStationVideoURL ?? "",
  //         songVideoUrl: selectedRadio?.streams?.radioStationVideoURL ?? "",
  //         createdAt: DateTime.now(),
  //         updatedAt: null,
  //         songDuration: '');
  //     radio1Collection = null;
  //     radio1Collection =
  //         _firestore.collection('${selectedRadio?.idRadioStation ?? 1}');
  //
  //     Stream<DocumentSnapshot> doc =
  //         radio1Collection!.doc('currentsong').snapshots();
  //
  //     doc.listen((event) {
  //       var data = SongModel.fromJson(event.data() as Map<String, dynamic>);
  //
  //       print("Radio Station ID Received ${data.idRadioStation}");
  //       print(
  //           "Radio Station ID Selected ${_radioStationController.selectedRadio?.idRadioStation}");
  //
  //       if (!dataList.contains(data) &&
  //           data.idRadioStation ==
  //               _radioStationController.selectedRadio?.idRadioStation) {
  //
  //         print("Adding new data From Firebase >>>>>>>>> "+data.toJson().toString());
  //
  //         dataList.insert(0, data);
  //         //radioSongdata = dataList[0];
  //         radioSongdata.songTitle = data.songTitle;
  //         radioSongdata.songArtist = data.songArtist;
  //         radioSongdata.songAlbum = data.songAlbum;
  //         radioSongdata.songGenre = data.songGenre;
  //         radioSongdata.songAudioUrl =
  //             selectedRadio?.streams?.radioStationAudioURL ?? "";
  //        // print("url playing is " + radioSongdata.songAudioUrl);
  //
  //         // radioSongdata.songImage = data.songImage;
  //       }
  //
  //       print("new data list " + dataList.length.toString());
  //       refresh();
  //     });
  //
  //     //currentSongdata = radioSong;
  //
  //     print("Playing Radio " + radioSongdata.songTitle);
  //     print("Playing RADIO URL " + radioSongdata.songAudioUrl);
  //     print("Auto Start " + autoStart.toString());
  //
  //     try {
  //       await assetsAudioPlayer.stop();
  //       try {
  //         await assetsAudioPlayer.setAudioSource(
  //           AudioSource.uri(
  //             Uri.parse(radioSongdata.songAudioUrl),
  //           ),
  //         );
  //         if (autoStart) {
  //           await assetsAudioPlayer.stop();
  //           await assetsAudioPlayer.play();
  //         }
  //       } catch (e, s) {
  //         print("Error loading audio source: $e $s");
  //       }
  //
  //       // await assetsAudioPlayer.open(
  //       //     Audio.liveStream(radioSongdata.songAudioUrl),
  //       //     // Audio.liveStream("https://streamingv2.shoutcast.com/radio-jan"),
  //       //     showNotification: false,
  //       //     autoStart: autoStart);
  //       print("radioSongdata.songAudioUrl: " + radioSongdata.songAudioUrl);
  //
  //       //scrollcontroller.jumpTo(0);
  //     } catch (t) {
  //       isPlayingRadio = false;
  //       print(t);
  //       //mp3 unreachable
  //       print("can not play the song from radio url");
  //     }
  //     notifyChildrens();
  //   }
  // }

  playRadioSongFromRadioStation(
      {bool autoStart = false, bool reload = false}) async {
    //Firebase
    var selectedRadio = _radioStationController.selectedRadio;
    radioSongdata = SongModel(
        idSong: 0,
        idRadioStation: selectedRadio?.idRadioStation ?? 1,
        songTitle: selectedRadio?.radioStationName ?? "Radio",
        songArtist: selectedRadio?.radioStationAddress ?? "",
        songAlbum: selectedRadio?.radioStationSlogan ?? "",
        songGenre: selectedRadio?.radioStationName ?? "",
        songImage: selectedRadio?.radioStationLogo ?? "",
        songAudioUrl: selectedRadio?.streams?.radioStationAudioURL ?? "",
        songYouTubeUrl: selectedRadio?.streams?.radioStationVideoURL ?? "",
        songVideoUrl: selectedRadio?.streams?.radioStationVideoURL ?? "",
        createdAt: DateTime.now(),
        updatedAt: null,
        songDuration: '');
    radio1Collection = null;
    radio1Collection =
        _firestore.collection('${selectedRadio?.idRadioStation ?? 1}');

    Stream<DocumentSnapshot> doc =
        radio1Collection!.doc('currentsong').snapshots();

    doc.listen((event) {
      if (event.data() != null) {
        var data = SongModel.fromJson(event.data() as Map<String, dynamic>);

        print("Data Received From Firebase");

        print("************* " + data.toJson().toString() + " *************");

        print("Radio Station ID Received ${data.idRadioStation}");
        print(
            "Radio Station ID Selected ${_radioStationController.selectedRadio?.idRadioStation}");

        if (!dataList.contains(data) &&
            data.idRadioStation ==
                _radioStationController.selectedRadio?.idRadioStation) {
          dataList.insert(0, data);
          refresh();
          print(
              "%%%%%%%%%%%%%%%%%%%%% DATA ADDDED FROM FIREBASE %%%%%%%%%%%%%%%%%%%%%%%%%");
          radioSongdata.songTitle = data.songTitle;
          radioSongdata.songArtist = data.songArtist;
          radioSongdata.songAlbum = data.songAlbum;
          radioSongdata.songGenre = data.songGenre;
          // radioSongdata.songAudioUrl =
          //     selectedRadio?.streams?.radioStationAudioURL ?? "";
          //print("url playing is " + radioSongdata.songAudioUrl);

          // var currentPos = -1;
          // currentPos = dataList.indexOf(currentSongdata);

          if (pageController.page == 0) {
            currentSongdata.songTitle = data.songTitle;
            currentSongdata.songArtist = data.songArtist;
            // currentSongdata.songAudioUrl =
            //     selectedRadio?.streams?.radioStationAudioURL ?? "";

            refresh();
          }
        }

        print("new data list " + dataList.length.toString());
      }
    });

    playNewSong(dataList[0], autoStart: true);
  }

  Future getSongsForFirstTime() async {
    setScreenState = screenStateLoading;
    currentPage = 1;
    lastPage = 1;
    update();
    var map = Map<String, dynamic>();

    map["radioStationId"] =
        _radioStationController.selectedRadio?.idRadioStation ?? 1;
    map['current_page'] = currentPage;
    var res = await getAllSongs(map);

    String text = '';

    if (res.isError!) text = XR().string.error_message;

    if (res.status == true) {
      try {
        dataList.clear();
        res.body['result'].forEach((v) {
          var data = SongModel.fromJson(v);
          dataList.add(data);
          print("^^^^ ${data.idBroadcasted} ^^^^^");
        });

        lastPage = res.body['last_page'];
        currentPage = res.body['current_page'];
        print("getSongsForFirstTime last page is " + lastPage.toString());
        setScreenState = screenStateOk;
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

    refresh();
  }

  Future likeSong(int songId, bool isLike) async {
    var map = <String, dynamic>{};
    var userID;

    if (Platform.isAndroid) {
      var info = await deviceInfo.androidInfo;
      userID = info.androidId;
      print(info.androidId);
    } else if (Platform.isIOS) {
      var info = await deviceInfo.iosInfo;
      userID = info.identifierForVendor;
      print("ios" + info.identifierForVendor.toString());
    }
    map['idRadioStation'] =
        _radioStationController.selectedRadio?.idRadioStation.toString();
    map['deviceID'] = userID;
    map['idSong'] = songId;
    map['rate'] = isLike ? "like" : "dislike";

    var res = await songRating(map);

    String text = '';

    if (res.isError!) text = XR().string.error_message;

    if (res.status == true) {
      showSimpleSuccessSnackBar(
          message: "Song ${isLike ? "like" : "dislike"} successfully");
      print("song liked");
    } else {
      text = res.text ?? "something went wrong";
      //showSimpleErrorSnackBar(message: text);
      // setScreenState = screenStateError;
    }

//    refresh();
  }

  Future getMoreSongsByPagination() async {
    print("more result called");
    var map = new Map<String, dynamic>();

    map["radioStationId"] =
        _radioStationController.selectedRadio?.idRadioStation ?? 1;
    map['current_page'] = currentPage + 1;
    var res = await getAllSongs(map);

    String text = '';

    if (res.isError!) {
      text = res.text ?? "something went wrong";
      showSimpleErrorSnackBar(message: text);
      text = XR().string.error_message;
    } else {
      if (res.status == true) {
        try {
          lastPage = res.body['last_page'];
          currentPage = res.body['current_page'];
          res.body['result'].forEach((v) {
            dataList.add(SongModel.fromJson(v));
          });
        } catch (e) {
          print("i m in catch");
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

  playNewSong(SongModel newsong, {bool autoStart = true}) async {
    print(newsong.toJson().toString());
    // if(newsong!=currentSongdata && !assetsAudioPlayer.isPlaying.value){
    //
    // }
    isPlayingRadio = false;
    currentSongdata = newsong;
    print("isRadio =>>>> ${newsong == dataList.first}");
    if (newsong == dataList.first) {
      currentSongdata.songAudioUrl = _radioStationController
              .selectedRadio?.streams?.radioStationAudioURL ??
          "";
      print("<<<<<<<<<<<<<<<<<<<Updated Song Link>>>>>>>>>>>>>>>>>>>>");
    }

    try {
      print("playing here new song ===> ${currentSongdata.songAudioUrl}");
      print("Auto Play True");

      await assetsAudioPlayer.stop();

      await assetsAudioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(currentSongdata.songAudioUrl),
        ),
      );
      if (autoStart) {
        await assetsAudioPlayer.play();
      }

      // await assetsAudioPlayer.open(Audio.network(currentSongdata.songAudioUrl),
      //     showNotification: false, autoStart: autoStart);
      // assetsAudioPlayer.current.listen((playingAudio) {
      //   totalDuration =
      //       playingAudio?.audio.duration ?? const Duration(seconds: 1);
      // });

      // assetsAudioPlayer.currentPosition.listen((event) {
      //   leftDuration = event;
      // });
    } catch (t, s) {
      print("Ajay");
      print(t);
      print(s);
      //mp3 unreachable
      print("can not play the song from url in play new song");
      if (t is! PlayerInterruptedException) {
        playNextSongFromList();
      }
    }
    refresh();
  }

  // Future<void> PlayOrPauseSong() async {
  //   print(" play pause method called");
  //   await assetsAudioPlayer.play();
  //   update();
  // }

  Future<void> seekToSecond(int second) async {
    Duration newDuration = Duration(milliseconds: second);
    await assetsAudioPlayer.seek(newDuration);
    update();
  }
}
