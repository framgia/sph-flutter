import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/src/controllers/auth_header_controller.dart';
import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/components/auth/components/logout_dropdown.dart';

/*
  Reusable "Top" component for auth related actions
  such as login, forgot password, create password

  @param hasAuthToken, bool value to tell if user is authenticated or not.

  @child, widgets to be passed on the child.
*/
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    this.hasAuthToken = false,
    required this.child,
  });

  final bool hasAuthToken;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    AuthHeaderController controller = Get.put(AuthHeaderController());
    const storage = FlutterSecureStorage();

    void dropdownCallback(selectedValue) async {
      if (selectedValue == 'logout') {
        final client = NetworkConfig().client;

        final logoutResponse = await client.post(
          logoutUrl,
        );

        if (logoutResponse.statusCode == HttpStatus.ok) {
          final message = logoutResponse.data['data']['message'];

          // delete the stored login token
          await storage.delete(key: StorageKeys.loginToken.name);

          Get.offAll(() => const LoginPage());

          showSnackbar(
            title: 'Success',
            content: message,
          );
        } else if (logoutResponse.statusCode == HttpStatus.badRequest) {
          showAlertDialog(
            title: 'ERROR',
            content: 'An error occurred while logging out.',
          );
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                child: Image.asset(
                  'assets/images/corner.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 62, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Image.asset('assets/images/sph-flutter-logo.png'),
                    ),
                    Visibility(
                      visible: hasAuthToken,
                      child: SizedBox(
                        height: 25,
                        child: FutureBuilder(
                          future: controller.getFullName(),
                          builder: (context, snapshot) {
                            return LogoutDropdown(
                              defaultValue: controller.name,
                              selectedValue: 'logout',
                              onChanged: dropdownCallback,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !hasAuthToken,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 225, bottom: 33),
                    child: Column(
                      children: [
                        Text(
                          'Savings App',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 11),
                        SizedBox(
                          width: 220,
                          child: Text(
                            'Monitor your savings, your balance, and transaction history',
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
