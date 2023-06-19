import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
    final formKey = GlobalKey<FormBuilderState>();

    return SafeArea(
      child: Scaffold(
        body: AuthHeader(
          child: FormBuilder(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              formKey.currentState!.save();
            },
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
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
                          validator: FormBuilderValidators.email(),
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
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                  color: const Color.fromARGB(255, 0, 163, 255),
                                ),
                          ),
                        ),
                      ),
                      Button(
                        text: 'Send',
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 99),
                        onPressed: () {
                          if (formKey.currentState?.isValid ?? false) {
                            debugPrint(formKey.currentState?.value.toString());
                            Get.back();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
