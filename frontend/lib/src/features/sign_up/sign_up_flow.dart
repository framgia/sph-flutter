import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:get/get.dart';

import 'package:frontend/src/controllers/sign_up_controller.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/features/sign_up/sign_up_step_one.dart';
import 'package:frontend/src/features/sign_up/sign_up_step_two.dart';

/*
  The class for the sign up form data used in FlowBuilder state
*/
class UserFormData {
  const UserFormData({
    this.firstName,
    this.middleName,
    this.lastName,
    this.address,
    this.birthday,
    this.username,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.page,
  });

  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? address;
  final DateTime? birthday;
  final String? username;
  final String? email;
  final String? password;
  final String? passwordConfirmation;
  final int? page;

  UserFormData copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? address,
    DateTime? birthday,
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    int? page,
  }) {
    return UserFormData(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      birthday: birthday ?? this.birthday,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      page: page ?? this.page,
    );
  }
}

/*
  The class that controls the flow of sign up pages.
*/
class SignUpFlow extends StatelessWidget {
  const SignUpFlow({Key? key}) : super(key: key);

  static Route<UserFormData> route() {
    return MaterialPageRoute(builder: (_) => const SignUpFlow());
  }

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());

    return SafeArea(
      child: Scaffold(
        body: FlowBuilder<UserFormData>(
          state: const UserFormData(),
          onGeneratePages: (userFormData, pages) {
            return [
              MaterialPage(
                child: GestureDetector(
                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                  child: AuthHeader(
                    child: Column(
                      children: [
                        if (userFormData.page == null || userFormData.page == 1)
                          SignUpStepOne(userFormData: userFormData),
                        if (userFormData.page == 2)
                          SignUpStepTwo(userFormData: userFormData),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                signUpController
                                  ..setSignUpFirstButtonEnabled = false
                                  ..setSignUpSecondButtonEnabled = false;
                                Get.to(() => const LoginPage());
                              },
                              child: Text(
                                'Log in',
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                      color: const Color.fromARGB(255, 0, 163, 255),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 150)
                      ],
                    ),
                  ),
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
