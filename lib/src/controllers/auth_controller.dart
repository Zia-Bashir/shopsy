import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsy/src/firebase/firebase_references.dart';

import '../base/loading_widget.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  late Rx<User?> _user;
  Rx<User?> get user => _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    // ever(_user, _initialScreen);
  }

  // _initialScreen(User? user) {
  //   if (user == null) {
  //     //* ---- login Screen ----
  //     Get.offAllNamed("/login");
  //   } else {
  //     Get.offAllNamed('/home'); //* ---- Home Screen ----
  //   }
  // }

  //* -- Registration

  registration(String email, password) async {
    try {
      Get.showOverlay(
        loadingWidget: const Loading(),
        asyncFunction: () async {
          return await auth
              .createUserWithEmailAndPassword(email: email, password: password)
              .then((value) => {
                    userRF.doc(value.user!.uid).set({
                      "uid": value.user!.uid,
                      "email": value.user!.email,
                      "firstName": null,
                      "lastName": null,
                      "phoneNumber": null,
                      "address": null,
                      "postalCode": null,
                      "profileImg": null,
                      "profileUpdated": false,
                      "emailVerfied": false,
                    }),
                  });
        },
      );
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("login", false);
      Get.offAllNamed("/complete");
    } catch (e) {
      Get.snackbar("About User", "User Message",
          titleText: const Text("Account Creation Failed"),
          snackPosition: SnackPosition.BOTTOM,
          messageText: Text(e.toString()));
    }
  }

  //* -- Complete Registration

  completeRegistration(String firstName, lastName, number, address) async {
    try {
      Get.showOverlay(
        loadingWidget: const Loading(),
        asyncFunction: () async {
          return await userRF.doc(auth.currentUser!.uid).update({
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": number,
            "address": address,
            "profileUpdated": true,
          });
        },
      );
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("login", true);
      Get.offAllNamed("/success");
    } catch (e) {
      Get.snackbar("About User", "User Message",
          titleText: const Text("Failed..."),
          snackPosition: SnackPosition.BOTTOM,
          messageText: Text(e.toString()));
    }
  }

  //* -- Login

  login(String email, password) async {
    try {
      Get.showOverlay(
        loadingWidget: const Loading(),
        asyncFunction: () async {
          return await auth.signInWithEmailAndPassword(
              email: email, password: password);
        },
      );

      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool("login", true);

      final docRef = userRF.doc(auth.currentUser!.uid);
      docRef.get().then((DocumentSnapshot doc) {
        var profileUpdated = doc['profileUpdated'];
        if (profileUpdated == true) {
          Get.offAllNamed("/navbar");
        } else {
          Get.offAllNamed("/complete");
        }
      });
    } catch (e) {
      Get.snackbar("About User", "User Message",
          titleText: const Text("Login Failed"),
          snackPosition: SnackPosition.BOTTOM,
          messageText: Text(e.toString()));
    }
  }

  //* -- Logout

  signOut() async {
    Get.showOverlay(
      loadingWidget: const Loading(),
      asyncFunction: () async {
        return await auth.signOut();
      },
    );
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("login", false);
    Get.offAllNamed("/login");
  }
}
