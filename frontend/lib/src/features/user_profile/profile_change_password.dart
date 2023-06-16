import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:frontend/src/navigators/profile_screen_navigator.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';

/*
  The page where user can change their password.
*/
class ProfileChangePassword extends StatelessWidget {
  const ProfileChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Breadcrumb(
              text: 'Change Password',
              onTap: () {
                return profileAppNav.currentState?.popUntil((route) {
                  return route.isFirst;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 21, 25, 150),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InputField(
                      name: 'old_password',
                      label: 'Old Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    const InputField(
                      name: 'new_password',
                      label: 'New Password',
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    // TODO: checkout password confirmation mechanics of laravel, they are using some naming conventions
                    const InputField(
                      name: 'confirm_new_password',
                      label: 'Confrim New Password',
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Button(
                            text: 'Save',
                            onPressed: () {
                              if (formKey.currentState?.saveAndValidate() ?? false) {
                                debugPrint(formKey.currentState?.value.toString());
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
