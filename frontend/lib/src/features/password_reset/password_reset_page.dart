import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/src/controllers/login_controller.dart';
import 'package:frontend/src/features/password_reset/components/reset_password_page.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
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
class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({super.key});
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

      final email = formKey.currentState!.fields['email']!.value;

      final forgotPasswordResponse = await client.post(
        forgotPasswordtUrl,
        data: {
          'email': email,
        },
      );

      if (forgotPasswordResponse.statusCode == HttpStatus.badRequest) {
        // the error response is in Response<dynamic>, toString + jsonDecode to easily access data
        final error = jsonDecode(forgotPasswordResponse.data.toString());
        // just use the first validation error (if many)
        final message = error['error']['message']['email'][0];
        message == 'The selected email is invalid.'
            ? formKey.currentState?.fields['email']?.invalidate(message)
            : showAlertDialog(
                title: 'ERROR',
                content: message,
                onClick: () {
                  Get.to(ResetPasswordPage(emailValue: email));
                },
              );
      } else {
        showAlertDialog(
          title: 'SUCCESS',
          content: 'The link was sent, please check your email',
          onClick: () {
            Get.to(ResetPasswordPage(emailValue: email));
          },
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        body: AuthHeader(
          child: GetX<LoginController>(
            builder: (_) => FormBuilder(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              onChanged: () {
                formKey.currentState!.save();

                // when email is invalidated on the onSubmit,
                // revalidate the email field when typing again
                formKey.currentState?.fields['email']
                    ?.validate(focusOnInvalid: false);

                // set button enabled state
                loginController.setLoginButtonEnabled =
                    formKey.currentState!.fields['email']!.isValid;
              },
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Forgot Password',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: InputField(
                            name: 'email',
                            label: 'Enter Email',
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ],
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
