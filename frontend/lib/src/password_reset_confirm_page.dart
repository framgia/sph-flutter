import 'package:flutter/material.dart';
import 'package:frontend/consts/colors.dart';
import 'package:frontend/main.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/auth/input_field.dart';
import 'package:get/get.dart';

class PasswordResetConfirmPage extends StatelessWidget {
  const PasswordResetConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: passwordResetBackgroundColor,
      body: Column(
        children: [
          const AuthHeader(),
          Container(
            // color: Colors.red,
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Enter Pin',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 73,
                        child: InputField(),
                      ),
                      SizedBox(
                        width: 73,
                        child: InputField(),
                      ),
                      SizedBox(
                        width: 73,
                        child: InputField(),
                      ),
                      SizedBox(
                        width: 73,
                        child: InputField(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Back to Login',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 44,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.blue,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue,
                      ),
                      foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(const MyHomePage(title: 'Flutter Demo Home Page'));
                    },
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
