import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
  Reusable alert dialog

  @param title: String value to display the title of the alert dialog

  @param content: String value to display the content of the alert dialog

  @param onClick: VoidCallback function to execute when the user clicks "Okay"

*/

void showAlertDialog({
  required String title,
  required String content,
  VoidCallback? onClick,
}) {
  Get.dialog(
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onClick ?? () => Get.back(),
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}
