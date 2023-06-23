import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';
import 'package:frontend/src/helper/storage.dart';

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
    const storage = FlutterSecureStorage();
    final networkConfig = NetworkConfig();

    void dropdownCallback(selectedValue) async {
      if (selectedValue == 'logout') {
        final client = networkConfig.client;

        final logoutResponse = await client.post(
          logoutUrl,
        );

        if (logoutResponse.statusCode == HttpStatus.ok) {
          final message = logoutResponse.data['data']['message'];

          // delete the stored login key
          await storage.delete(key: loginTokenKey);

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
                        child: DropdownButton(
                          value: 'user',
                          onChanged: dropdownCallback,
                          items: [
                            const DropdownMenuItem(
                              value: 'user',
                              child: Text(
                                'JOASH C. CAÑETE',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'logout',
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),

                                alignment: Alignment
                                    .center, // Center the text vertically and horizontally
                                child: Text(
                                  'Log out',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall, // Customize the text color
                                ),
                              ),
                            ),
                          ],
                          style: Theme.of(context).textTheme.titleSmall,
                          underline: Container(), // Remove the underline
                          iconSize: 0, // Add a custom dropdown icon
                          dropdownColor: Colors.transparent,
                          elevation: 0,
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
