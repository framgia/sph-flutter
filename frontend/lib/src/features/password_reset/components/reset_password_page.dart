import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/src/controllers/login_controller.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:get/get.dart';

import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';

/*
  Page for the Password Reset
  User inputs email
*/
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key, required this.emailValue});

  final String emailValue;
  @override
  Widget build(BuildContext context) {
    //LoginController is being used here
    //so that the button will disable and to avoid duplicated code
    final LoginController loginController = Get.put(LoginController());
    final formKey = GlobalKey<FormBuilderState>();
    final networkConfig = NetworkConfig();

    void onSubmit() async {
      // disable the button to prevent multiple requests being sent
      loginController.setLoginButtonEnabled = false;

      final client = networkConfig.client;

      final email = emailValue;
      final password = formKey.currentState!.fields['password']!.value;
      final passwordConfirmation =
          formKey.currentState!.fields['password_confirmation']!.value;
      final token = formKey.currentState!.fields['token']!.value;

      final resetPasswordResponse = await client.post(
        resetPasswordtUrl,
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'token': token,
        },
      );

      if (resetPasswordResponse.statusCode == HttpStatus.ok) {
        Get.to(() => const LoginPage());
      } else if (resetPasswordResponse.statusCode == HttpStatus.badRequest) {
        // the error response is in Response<dynamic>, toString + jsonDecode to easily access data
        final error = jsonDecode(resetPasswordResponse.data.toString());
        // just use the first validation error (if many)
        final message = error['error']['message']['password'][0];

        message == 'password should not be an old password'
            ? formKey.currentState?.fields['password']?.invalidate(message)
            : message == 'The password confirmation does not match.'
                ? formKey.currentState?.fields['password_confirmation']
                    ?.invalidate(message)
                : formKey.currentState?.fields['token']?.invalidate(message);
      }
    }

    return SafeArea(
      child: Scaffold(
        body: AuthHeader(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 150),
            child: GetX<LoginController>(
              builder: (_) => FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: () {
                  formKey.currentState!.save();

                  // when password is invalidated on the onSubmit,
                  // revalidate the password field when typing again
                  formKey.currentState?.fields['password']
                      ?.validate(focusOnInvalid: false);

                  // set button enabled state
                  loginController.setLoginButtonEnabled =
                      formKey.currentState!.fields['password']!.isValid &&
                          formKey.currentState!.fields['password_confirmation']!
                              .isValid &&
                          formKey.currentState!.fields['token']!.isValid;
                },
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Create New Password',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            children: [
                              InputField(
                                name: 'password',
                                label: 'Password',
                                inputType: TextInputType.visiblePassword,
                                obscureText: true,
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(
                                height: 36,
                              ),
                              InputField(
                                name: 'password_confirmation',
                                label: 'Confirm Password',
                                inputType: TextInputType.visiblePassword,
                                obscureText: true,
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(
                                height: 36,
                              ),
                              InputField(
                                name: 'token',
                                label: 'Token',
                                inputType: TextInputType.text,
                                validator: FormBuilderValidators.required(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(bottom: 60),
                          child: TextButton(
                            onPressed: () {
                              Get.to(() => const LoginPage());
                            },
                            child: Text(
                              'Back to Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color:
                                        const Color.fromARGB(255, 0, 163, 255),
                                  ),
                            ),
                          ),
                        ),
                        Button(
                          onPressed: loginController.loginButtonEnabled
                              ? onSubmit
                              : null,
                          buttonColor: loginController.loginButtonEnabled
                              ? const Color(0xFF00CCFF)
                              : Colors.grey,
                          text: 'Send',
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 99,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
