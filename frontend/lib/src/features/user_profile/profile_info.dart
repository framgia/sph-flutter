import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/navigators/profile_screen_navigator.dart';

/*
  The page where user can see their profile informations.
*/
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Breadcrumb(
              text: 'Profile Info',
              withBackIcon: false,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 21, 25, 150),
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InputField(
                      name: 'first_name',
                      label: 'First Name',
                    ),
                    const SizedBox(height: 26),
                    const InputField(
                      name: 'middle_name',
                      label: 'Middle Name',
                    ),
                    const SizedBox(height: 26),
                    const InputField(
                      name: 'last_name',
                      label: 'Last Name',
                    ),
                    const SizedBox(height: 26),
                    InputField(
                      name: 'email',
                      validator: FormBuilderValidators.email(),
                      label: 'Email',
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 26),
                    const InputField(
                      name: 'user_name',
                      label: 'Username',
                    ),
                    const SizedBox(height: 26),
                    const InputField(
                      name: 'address',
                      label: 'Address',
                    ),
                    const SizedBox(height: 26),
                    const DatePickerField(
                      name: 'birthday',
                      labelText: 'Birthday',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              profileAppNav.currentState
                                  ?.pushNamed('/profileChangePassword');
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                            ),
                            child: Text(
                              'Change Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .apply(bodyColor: const Color(0xFF00A3FF))
                                  .labelSmall,
                            ),
                          ),
                          Button(
                            text: 'Save',
                            onPressed: () {
                              if (formKey.currentState?.saveAndValidate() ?? false) {
                                debugPrint(formKey.currentState?.value.toString());
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
          ],
        ),
      ),
    );
  }
}
