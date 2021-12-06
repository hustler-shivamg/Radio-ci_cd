library perspective_pageview;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:my_radio_app/Screens/Playlist_screen/playlist_binding.dart';
import 'package:my_radio_app/base/base_controller.dart';
import 'package:provider/provider.dart';

enum PVAspectRatio {
  ONE_ONE,
  SIXTEEN_NINE,
}

class PerspectivePageView extends StatefulWidget {
  final List<Widget> children;
  final bool hasShadow;
  final bool attachScroll;
  final Color shadowColor;
  final PVAspectRatio? aspectRatio;
  final String mKey;

  PerspectivePageView(
      {required this.children,
      required this.hasShadow,
      required this.attachScroll,
      required this.shadowColor,
      this.aspectRatio,
      required this.mKey});

  @override
  _PerspectivePageViewState createState() => _PerspectivePageViewState();
}

class _PerspectivePageViewState extends State<PerspectivePageView> {
  late PageValueHolder holder;
  double fraction = 0.50;

  PlaylistController playlistController = Get.find();

  getAspectRatio() {
    switch (widget.aspectRatio) {
      case PVAspectRatio.ONE_ONE:
        return [1.0, 1.6];
        break;
      case PVAspectRatio.SIXTEEN_NINE:
        return [16 / 9, 1.1];
        break;
      default:
        return [1.0, 1.6];
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    holder = PageValueHolder(0.0);
    playlistController.pageController =
        PageController(viewportFraction: fraction, initialPage: 0);
    playlistController.pageController.addListener(() {
      holder.setValue(playlistController.pageController.page);
    });
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }
  var curruntPage = 0;

  @override
  Widget build(BuildContext context) {
    final List<num> arAndShadow = getAspectRatio();
    return Container(
      child: Center(
        child: AspectRatio(
          aspectRatio: arAndShadow[0].toDouble(),
          child: ChangeNotifierProvider<PageValueHolder>.value(
            value: holder,
            child: PageView.builder(
              reverse: true,
                key: Key(widget.mKey),
                onPageChanged: (value) {
                  curruntPage = value;
                  print("Slider moved");
                  if (playlistController.isPlayingRadio) {

                  } else {
                    playlistController
                        .playNewSong(playlistController.dataList[value]);
                    var length = playlistController.dataList.length;
                    if (value == length - 5) {
                      print("call api for pagination here");
                      playlistController.getMoreSongOnSliderChange();
                    }
                  }
                  setState(() {

                  });
                },
                controller: playlistController.pageController,
                itemCount: widget.children.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Opacity(
                    opacity: curruntPage == index ? 1 : 0.5,
                    child: MyPage(
                        child: widget.children[index],
                        number: index,
                        fraction: fraction,
                        hasShadow: widget.hasShadow,
                        shadowColor: widget.shadowColor,
                        shadowScale: arAndShadow[1].toDouble()),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final int number;
  final double fraction;
  final Widget child;
  final Color shadowColor;
  final bool hasShadow;
  final double shadowScale;

  MyPage(
      {required this.child,
      required this.number,
      required this.fraction,
      required this.hasShadow,
      required this.shadowColor,
      required this.shadowScale});

  @override
  Widget build(BuildContext context) {
    double value = Provider.of<PageValueHolder>(context).value;
    double diff = (number - value);

    final Matrix4 pvMatrix = Matrix4.identity()
      ..setEntry(3, 3, 1 / 1) // Increasing Scale by 90%
      ..setEntry(1, 1, 0.9) // Changing Scale Along Y Axis
      ..setEntry(3, 0, 0.004 * diff); // Changing Perspective Along X Axis

    return Transform(
      transform: pvMatrix,
      alignment: FractionalOffset.center,
      child: Container(
        child: child,
      ),
    );
  }
}

class PageValueHolder extends ChangeNotifier {
  double? _value;

  PageValueHolder(value) {
    this._value = value;
  }

  get value => this._value;

  void setValue(newValue) {
    this._value = newValue;
    notifyListeners();
  }
}
