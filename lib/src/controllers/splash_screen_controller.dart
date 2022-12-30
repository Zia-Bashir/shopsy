// ignore_for_file: unnecessary_null_comparison

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsy/src/controllers/auth_controller.dart';

class SplashController extends GetxController {
  RxBool animate = false.obs;
  static AuthController authController = Get.find();
  //static SharedPrefController sPController = Get.find();

  Future<void> startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;

    //= Shared Preference

    final SharedPreferences pref = await SharedPreferences.getInstance();

    //// OnBoarding
    var onBoarding = pref.get("onboarding");
    await pref.setBool("onboarding", true);
    //// Login
    var logIn = pref.get("login");

    Future.delayed(const Duration(seconds: 5), (() {
      if (onBoarding == true) {
        if (logIn == true) {
          Get.offAllNamed("/navbar");
        } else {
          Get.offAllNamed("/login");
        }
      } else {
        Get.offAllNamed("/onboarding");
      }
    }));

    // var isBoarding = sPController.getOnboarding();
    // sPController.setOnboarding();

    // var isLogin = sPController.getLogIn();
    // Future.delayed(const Duration(seconds: 5), (() {
    //   if (isBoarding == true) {
    //     if (isLogin == true) {
    //       Get.offAllNamed("/home");
    //     } else {
    //       Get.offAllNamed("/login");
    //     }
    //   } else {
    //     Get.offAllNamed("/onboarding");
    //   }
    // }));
  }
}
