import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_radio_app/x_routes/router_name.dart';
import 'x_routes/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
  //   print(notification.audioId);
  //   return true;
  // });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {});
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      print("firebase done");
      return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: () => LayoutBuilder(
          builder: (context, constraints) {
            return GetMaterialApp(
              theme: ThemeData(
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: const Color(0xffAA3DD9))),
              initialRoute: RouterName.homePage,
              debugShowCheckedModeBanner: false,
              getPages: Pages.pages(),
            );
          },
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
