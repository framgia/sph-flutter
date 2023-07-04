import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';
import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/controllers/reset_password_controller.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';

/*
  Page for the Reset Password
  User inputs Password, Confirm Password and Token
*/
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key, required this.emailValue});

  final String emailValue;

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller =
        Get.put(ResetPasswordController());
    final formKey = GlobalKey<FormBuilderState>();

    void onSubmit() async {
      // disable the button to prevent multiple requests being sent
      controller.setResetPasswordButtonEnabled = false;

      final client = NetworkConfig().client;

      final email = emailValue;

      final resetPasswordResponse = await client.post(
        resetPasswordtUrl,
        data: {
          'email': email,
          'password': controller.password,
          'password_confirmation': controller.passwordConfirmation,
          'token': controller.token,
        },
      );

      if (resetPasswordResponse.statusCode == HttpStatus.ok) {
        final message = resetPasswordResponse.data['data']['message'];

        Get.to(() => const LoginPage());

        showSnackbar(
          title: 'Success',
          content: message,
        );
      } else if (resetPasswordResponse.statusCode == HttpStatus.badRequest) {
        // the error response is in Response<dynamic>, toString + jsonDecode to easily access data
        final error = jsonDecode(resetPasswordResponse.data.toString());
        // just use the first validation error (if many)
        final message = error['error']['message']['password'][0];

        if (message ==
            'New password must be different from the old password.') {
          formKey.currentState?.fields['password']?.invalidate(message);
        } else {
          formKey.currentState?.fields['token']?.invalidate(message);
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        body: AuthHeader(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 150),
            child: GetX<ResetPasswordController>(
              builder: (_) => FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: () {
                  formKey.currentState!.save();

                  // when password is invalidated on the onSubmit,
                  // revalidate the password field when typing again
                  formKey.currentState?.fields['password']
                      ?.validate(focusOnInvalid: false);
                  formKey.currentState?.fields['password_confirmation']
                      ?.validate(focusOnInvalid: false);
                  formKey.currentState?.fields['token']
                      ?.validate(focusOnInvalid: false);

                  controller.setPassword =
                      formKey.currentState?.fields['password']?.value ?? '';
                  controller.setpasswordConfirmation = formKey.currentState
                          ?.fields['password_confirmation']?.value ??
                      '';
                  controller.setToken =
                      formKey.currentState?.fields['token']?.value ?? '';

                  controller.setResetPasswordButtonEnabled =
                      formKey.currentState?.isValid ?? false;
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
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.equal(
                                    controller.password,
                                    errorText: "New password does not match.",
                                  ),
                                ]),
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
                          onPressed: controller.resetPasswordButtonEnabled
                              ? onSubmit
                              : null,
                          buttonColor: controller.resetPasswordButtonEnabled
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
