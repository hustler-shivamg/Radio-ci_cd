import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Playlist_screen/playlist_binding.dart';

class NetworkErrorPage extends StatelessWidget {
  NetworkErrorPage({Key? key}) : super(key: key);
  Color bottom = Colors.blue.shade700;
  Color top = Colors.red;
  @override
  Widget build(BuildContext context) {
    final PlaylistController countController = Get.find();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [0.15, 0.3, 0.8],
            colors: [top, Colors.purple, bottom],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/images/no_internet.png'),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  // '404',
                  "Oops,",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      letterSpacing: 2,
                      color: Colors.white,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  // 'Sorry, we couldn\'t find the page!',
                  "No Internet Connection Available",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    countController.onInit();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 50),
                      primary: Colors.redAccent),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
