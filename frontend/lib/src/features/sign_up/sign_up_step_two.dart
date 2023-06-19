import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:get/get.dart';

import 'package:frontend/src/features/sign_up/components/breadcrumb.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/features/login/login_page.dart';

class SignUpStepTwo extends StatelessWidget {
  const SignUpStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AuthHeader(
              child: Column(
                children: [
                  const Breadcrumb(
                    text: 'Sign Up',
                    page: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 30, 25, 150),
                    child: FormBuilder(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const InputField(
                            label: 'Username',
                            name: 'username',
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 26),
                          InputField(
                            label: 'Email',
                            name: 'email',
                            inputType: TextInputType.emailAddress,
                            validator: FormBuilderValidators.email(),
                          ),
                          const SizedBox(height: 26),
                          const InputField(
                            label: 'Password',
                            name: 'password',
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          const SizedBox(height: 26),
                          const InputField(
                            label: 'Confirm Password',
                            name: 'password_confirmation',
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Button(
                                  text: 'Sign Up',
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 99,
                                    vertical: 16,
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      debugPrint(
                                        formKey.currentState?.value.toString(),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const LoginPage());
                                },
                                child: Text(
                                  'Log in',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          163,
                                          255,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
