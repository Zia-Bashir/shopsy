import 'package:flutter/material.dart';
import 'package:get/get.dart';

snackBarWidget(String title, String message) {
  return Get.snackbar(
    title,
    message,
    icon: const Icon(Icons.person, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade500,
    borderRadius: 20,
    margin: const EdgeInsets.all(15),
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    dismissDirection: DismissDirection.startToEnd,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
