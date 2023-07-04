import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/controllers/forgot_password_controller.dart';
import 'package:frontend/src/features/password_reset/components/reset_password_page.dart';
import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/helper/dio.dart';

/*
  Page for the Forgot Password
  User inputs email
*/
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller =
        Get.put(ForgotPasswordController());
    final formKey = GlobalKey<FormBuilderState>();

    void onSubmit() async {
      // disable the button to prevent multiple requests being sent
      controller.setForgotPasswordButtonEnabled = false;

      final client = NetworkConfig().client;

      final email = formKey.currentState!.fields['email']!.value;

      final forgotPasswordResponse = await client.post(
        forgotPasswordUrl,
        data: {
          'email': email,
        },
      );

      if (forgotPasswordResponse.statusCode == HttpStatus.ok) {
        final message = forgotPasswordResponse.data['data']['message'];

        showAlertDialog(
          title: 'SUCCESS',
          content: message,
          onClick: () {
            Get.to(() => ResetPasswordPage(emailValue: email));
          },
        );
      } else if (forgotPasswordResponse.statusCode == HttpStatus.badRequest) {
        // the error response is in Response<dynamic>, toString + jsonDecode to easily access data
        final error = jsonDecode(forgotPasswordResponse.data.toString());
        final message = error['error']['message']['email'][0];
        final throttledMessage = error['error']['message']['short']?[0];

        if (message == "The email you entered isn't connected to an account.") {
          formKey.currentState?.fields['email']?.invalidate(message);
        }

        if (throttledMessage == "throttled") {
          showAlertDialog(
            title: 'ERROR',
            content: message,
            onClick: () {
              Get.to(() => ResetPasswordPage(emailValue: email));
            },
          );
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        body: AuthHeader(
          child: GetX<ForgotPasswordController>(
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
                controller.setForgotPasswordButtonEnabled =
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
                          onPressed: controller.forgotPasswordButtonEnabled
                              ? onSubmit
                              : null,
                          buttonColor: controller.forgotPasswordButtonEnabled
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
