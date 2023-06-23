import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
  Reusable snackbar

  @param title: String value to display the title of the snackbar

  @param content: String value to display the content of the snackbar
*/

void showSnackbar({
  required String title,
  required String content,
}) {
  Get.snackbar(
    title,
    content,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.white,
    colorText: const Color(0xFF6D7881),
  );
}
