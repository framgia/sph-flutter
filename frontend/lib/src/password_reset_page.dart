import 'package:flutter/material.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/auth/input_field.dart';
import 'package:frontend/src/password_reset_confirm_page.dart';
import 'package:get/get.dart';

class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(),
            Container(
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
                      'Enter Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: const InputField(),
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
                        Get.to(() => const PasswordResetConfirmPage());
                      },
                      child: const Text(
                        'SEND',
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
      ),
    );
  }
}
