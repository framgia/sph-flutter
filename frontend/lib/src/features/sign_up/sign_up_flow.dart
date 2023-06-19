import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import 'package:frontend/src/features/sign_up/sign_up_step_one.dart';
import 'package:frontend/src/features/sign_up/sign_up_step_two.dart';

/*
  The page where user can see their profile informations.
*/

class User {
  const User({
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

  User copyWith({
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
    return User(
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

class SignUpFlow extends StatelessWidget {
  const SignUpFlow({Key? key}) : super(key: key);

  static Route<User> route() {
    return MaterialPageRoute(builder: (_) => const SignUpFlow());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlowBuilder<User>(
        state: const User(),
        onGeneratePages: (user, pages) {
          return [
            if (user.page == null || user.page == 1) ...[
              const MaterialPage(
                child: SignUpStepOne(),
              ),
            ],
            if (user.page == 2) ...[
              const MaterialPage(
                child: SignUpStepTwo(),
              ),
            ]
          ];
        },
      ),
    );
  }
}
