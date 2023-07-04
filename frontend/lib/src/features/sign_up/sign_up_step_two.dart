import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:get/get.dart';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/features/sign_up/sign_up_flow.dart';
import 'package:frontend/src/controllers/sign_up_controller.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';

/*
  The page where user can fill the second page of sign up.

  @param, userFormData, the current sign up flow data.
*/
class SignUpStepTwo extends StatelessWidget {
  const SignUpStepTwo({super.key, required this.userFormData});

  final UserFormData userFormData;

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());
    final formKey = GlobalKey<FormBuilderState>();

    void onSubmit() async {
      signUpController.setSignUpSecondButtonEnabled = false;

      await NetworkConfig().getCsrftoken();
      final client = NetworkConfig().client;

      try {
        final signUpResponse = await client.post(
          authUrl,
          data: {
            'first_name': userFormData.firstName,
            'middle_name': userFormData.middleName,
            'last_name': userFormData.lastName,
            'address': userFormData.address,
            'birthday': userFormData.birthday.toString(),
            'user_name': formKey.currentState!.fields['username']!.value,
            'email': formKey.currentState!.fields['email']!.value,
            'password': formKey.currentState!.fields['password']!.value,
            'password_confirmation':
                formKey.currentState!.fields['password_confirmation']!.value,
          },
        );

        if (signUpResponse.statusCode == HttpStatus.ok) {
          Get.offAll(() => const LoginPage());

          showSnackbar(
            title: 'Success',
            content: 'Created an account successfully.',
          );
        } else if (signUpResponse.statusCode == HttpStatus.badRequest) {
          final error = jsonDecode(signUpResponse.data.toString());

          final message = error['error']['message'];
          final emailError = message['email'];
          final passwordError = message['password'];

          if (emailError != null) {
            formKey.currentState?.fields['email']?.invalidate(emailError[0]);
          }

          if (passwordError != null) {
            formKey.currentState?.fields['password']
                ?.invalidate(passwordError[0]);
          }
        }
      } catch (e) {
        showSnackbar(
          title: 'Error',
          content: e.toString(),
        );
      }
    }

    void onUpdateFlowState() {
      context.flow<UserFormData>().update(
            (data) => data.copyWith(
              page: 1,
              username: formKey.currentState?.fields['username']?.value,
              email: formKey.currentState?.fields['email']?.value,
              password: formKey.currentState?.fields['password']?.value,
              passwordConfirmation:
                  formKey.currentState?.fields['password_confirmation']?.value,
            ),
          );
    }

    return GetX<SignUpController>(
      builder: (_) => Column(
        children: [
          Breadcrumb(
            text: 'Sign Up',
            onTap: onUpdateFlowState,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
            child: FormBuilder(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              onChanged: () {
                formKey.currentState?.save();

                formKey.currentState?.fields['email']
                    ?.validate(focusOnInvalid: false);
                formKey.currentState?.fields['password']
                    ?.validate(focusOnInvalid: false);
                formKey.currentState?.fields['password_confirmation']
                    ?.validate(focusOnInvalid: false);

                signUpController
                  ..setPassword =
                      formKey.currentState?.fields['password']?.value ?? ''
                  ..setSignUpSecondButtonEnabled =
                      formKey.currentState!.isValid;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    label: 'Username',
                    name: 'username',
                    initialValue: userFormData.username,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 26),
                  InputField(
                    label: 'Email',
                    name: 'email',
                    inputType: TextInputType.emailAddress,
                    initialValue: userFormData.email,
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  InputField(
                    label: 'Password',
                    name: 'password',
                    inputType: TextInputType.visiblePassword,
                    obscureText: true,
                    initialValue: userFormData.password,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 26),
                  InputField(
                    label: 'Confirm Password',
                    name: 'password_confirmation',
                    inputType: TextInputType.visiblePassword,
                    obscureText: true,
                    initialValue: userFormData.passwordConfirmation,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.equal(
                        signUpController.password,
                        errorText: 'Passwords do not match.',
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: 'Sign Up',
                          enabled: signUpController.signUpSecondButtonEnabled,
                          onPressed: onSubmit,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 99,
                            vertical: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
