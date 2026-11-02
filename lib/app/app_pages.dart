import 'package:firedetection_system/module/Alert/binding/Alertbinding.dart';
import 'package:firedetection_system/module/Alert/view/alertscreen.dart';
import 'package:firedetection_system/module/Splash/binding/splash_binding.dart';
import 'package:firedetection_system/module/auth/Accept%20invite/accept_invite_binding.dart';
import 'package:firedetection_system/module/auth/Accept%20invite/accept_invite_view.dart';
import 'package:firedetection_system/module/auth/log%20in/login.dart';
import 'package:firedetection_system/module/auth/register/register_binding.dart';
import 'package:firedetection_system/module/auth/register/register_view.dart';
import 'package:firedetection_system/module/firestation/binding/binding.dart';
import 'package:firedetection_system/module/firestation/view/FirestationScreen.dart';
import 'package:firedetection_system/module/home/binding/homebinding.dart';
import 'package:firedetection_system/module/home/view/homeScreen.dart';
import 'package:firedetection_system/module/navbar/binding/navbar_binding.dart';
import 'package:firedetection_system/module/navbar/view/navbar_view.dart';
import 'package:firedetection_system/module/profile/binding/profile_binding.dart';
import 'package:firedetection_system/module/profile/view/profileScreen.dart';
import 'package:get/get.dart';

import '../module/Splash/view/splashscreen.dart';
import '../module/auth/log in/binding.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      binding: RegisterBinding(),
      page: () => const RegisterView(),
    ),
    /*GetPage(
      name: AppRoutes.accept_invite,
      binding: AcceptInviteBinding(),
      page: () => const AcceptInviteView(),
    ),*/

    GetPage(
      name: AppRoutes.splash,
      binding: SplashBinding(),
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.navbar,
      binding: NavBinding(),
      page: () => const NavigationView(),
    ),
    GetPage(
      name: AppRoutes.home,
      binding: HomeBinding(),
      page: () => const Homescreen(),
    ),
    GetPage(
      name: AppRoutes.alerts,
      binding: AlertBinding(),
      page: () => const AlertsHistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      binding: ProfileBinding(),
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.station,
      binding: FirestationBinding(),
      page: () => FireStationScreen(),
    ),
  ];
}
