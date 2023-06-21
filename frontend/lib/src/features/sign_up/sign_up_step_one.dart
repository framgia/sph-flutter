import 'package:flutter/material.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import 'package:frontend/src/features/sign_up/sign_up_flow.dart';
import 'package:frontend/src/features/sign_up/components/breadcrumb.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/features/login/login_page.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';

/*
  The page where user can fill the first page of sign up.
*/
class SignUpStepOne extends StatelessWidget {
  const SignUpStepOne({super.key});

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
                            label: 'First Name',
                            name: 'first_name',
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 26),
                          const InputField(
                            label: 'Middle Name',
                            name: 'middle_name',
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 26),
                          const InputField(
                            label: 'Last Name',
                            name: 'last_name',
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 26),
                          const InputField(
                            label: 'Address',
                            name: 'address',
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(height: 26),
                          const DatePickerField(
                            name: 'birthday',
                            labelText: 'Birthday',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Button(
                                  text: 'Next',
                                  onPressed: () {
                                    context.flow<UserFormData>().update(
                                          (data) => data.copyWith(page: 2),
                                        );
                                  },
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 99,
                                    vertical: 16,
                                  ),
                                ),
                              ],
                            ),
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
