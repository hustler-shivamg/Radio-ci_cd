import 'package:get/get.dart';
import '../Screens/Homepage/home_screen_binding.dart';
import '../Screens/Homepage/homepage.dart';
import '../Screens/Playlist_screen/playlist_binding.dart';
import '../Screens/Playlist_screen/playlist_screen.dart';
import '../Screens/Videolisting_screen/video_listing_screen.dart';
import '../Screens/Videolisting_screen/videolisting_binding.dart';
import '../Screens/Videoprogram_screen/video_program_binding.dart';
import '../Screens/Videoprogram_screen/video_programs_screen.dart';
import '../Screens/Current_Screen/current_song.dart';
import '../Screens/video_player/videoplayer_screen.dart';
import '../Screens/youtube_player/youtube_screen.dart';
import 'router_name.dart';

class Pages {
  static List<GetPage> pages() {
    return [
      GetPage(
          name: RouterName.currentSong,
          page: () => CurrentSong(),
          binding: PlaylistScreenBinding()),
      GetPage(
          name: RouterName.playList,
          page: () => PlaylistScreen(),
          binding: PlaylistScreenBinding()),
      GetPage(
          name: RouterName.videoListing,
          page: () => VideoListingScreen(),
          binding: VideoListingScreenBinding()),
      GetPage(
          name: RouterName.videoPrograms,
          page: () => VideoProgramsScreen(),
          binding: VideoProgramScreenBinding()),
      GetPage(
        name: RouterName.ytPlayer,
        page: () => VideoPlayerPage(),
      ),
      GetPage(
        name: RouterName.videoPlayer,
        page: () => VideoPlayerScreen(),
      ),
      GetPage(
          name: RouterName.homePage,
          page: () => HomePage(),
          binding: HomeScreennBinding()),

      // GetPage(
      //   name: RouterName.dashboard,
      //   page: () => DashboardScreen(),
      //   binding: BindingsBuilder(() {
      //     Get.put(DashboardController());
      //   }),
      // ),
      // GetPage(
      //     name: RouterName.test,
      //     page: () => TestScreen(),
      //     binding: TestBinding()),
      // GetPage(
      //     name: RouterName.login,
      //     page: () => LoginScreen(),
      //     binding: LoginBinding()),
      // GetPage(
      //     name: RouterName.forgotPassword,
      //     page: () => ForgotPassword(),
      //     binding: ForgotBinding()),
      // GetPage(
      //     name: RouterName.caregiverList,
      //     page: () => CaregiversScreen(),
      //     binding: CaregiverBinding()),
      // GetPage(
      //   name: RouterName.driverList,
      //   page: () => DriversScreen(),
      //   binding: DriverBinding(),
      // ),
      // GetPage(
      //   name: RouterName.kinderGardanList,
      //   page: () => KindergardensScreen(),
      //   binding: KinderBinding(),
      // ),
      // GetPage(
      //     name: RouterName.pediaList,
      //     page: () => PediatriciansScreen(),
      //     binding: PediaBinding()),
      // GetPage(
      //   name: RouterName.entertermentList,
      //   page: () => EntertainmentScreen(),
      //   binding: EntertainmentBinding(),
      // ),
      // GetPage(
      //   name: RouterName.otherServiceList,
      //   page: () => OtherServicesScreen(),
      //   binding: OtherServicesBinding(),
      // ),
      // GetPage(
      //     name: RouterName.otpVerification,
      //     page: () => OTPVerificationScreen(),
      //     binding: OTPVerificationBinding()),
      // GetPage(
      //     name: RouterName.resetPassword,
      //     page: () => ResetPasswordScreen(),
      //     binding: ResetPassBinding()),
      // GetPage(
      //     name: RouterName.editReview,
      //     page: () => EditReviewScreen(),
      //     binding: EditReviewBinding()),
      // GetPage(
      //     name: RouterName.forgotPasswordOTP,
      //     page: () => ForgotOTPVerificationScreen(),
      //     binding: ForgotOTPVerificationBinding()),
      // GetPage(
      //     name: RouterName.signup,
      //     page: () => SignupScreen(),
      //     binding: SignupBinding()),
      // GetPage(
      //     name: RouterName.personalDetail,
      //     page: () => PersonalDetail(),
      //     binding: PersonalDetailBinding()),
      // GetPage(
      //     name: RouterName.caregiverDetail,
      //     page: () => CaregiverDetailScreen(),
      //     binding: ProviderDetailBinding()),
      // GetPage(
      //     name: RouterName.driverDetail,
      //     page: () => DriverDetailScreen(),
      //     binding: ProviderDetailBinding()),
      // GetPage(
      //     name: RouterName.pediatricianDetail,
      //     page: () => PediatricianDetailScreen(),
      //     binding: ProviderDetailBinding()),
      // GetPage(
      //     name: RouterName.kinderGardenDetailScreen,
      //     page: () => KinderGardenDetailScreen(),
      //     binding: ProviderDetailBinding()),
      // GetPage(
      //     name: RouterName.addReviewScreen,
      //     page: () => AddReviewScreen(),
      //     binding: AddReviewBinding()),
      // GetPage(
      //     name: RouterName.serviceproviderSignup,
      //     page: () => ServiceProviderSignup(),
      //     binding: ServiceProviderSignupBinding()),
      // GetPage(
      //     name: RouterName.myFav,
      //     page: () => MyFavScreen(),
      //     binding: MyFavBinding()),
      // GetPage(
      //     name: RouterName.myReviews,
      //     page: () => MyReviewsScreen(),
      //     binding: MyReviewsBinding()),
      // GetPage(
      //     name: RouterName.serviceProviderList,
      //     page: () => ServiceProviderListScreen(),
      //     binding: ServiceProviderListBinding()),
      // GetPage(
      //     name: RouterName.search,
      //     page: () => SearchScreen(),
      //     binding: SearchBinding()),
    ];
  }
}
