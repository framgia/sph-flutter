import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/controllers/auth_header_controller.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/navigators/profile_screen_navigator.dart';
import 'package:frontend/src/controllers/user_profile_controller.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';

/*
  The page where user can see their profile informations.
*/
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    UserProfileController controller = Get.put(UserProfileController());
    AuthHeaderController authHeaderController = Get.find();

    onSubmit() async {
      controller.setLoading = true;

      final updatedProfile =
          await controller.updateUserProfile(controller.user);

      if (updatedProfile.statusCode == HttpStatus.ok) {
        await authHeaderController.getFullName();
      }

      controller.setLoading = false;

      if (updatedProfile.statusCode == HttpStatus.ok) {
        showSnackbar(
          title: "Success",
          content: "Profile updated successfully.",
        );
      } else {
        showSnackbar(
          title: "Failed",
          content: "Missing field.",
        );
      }
    }

    return GetX<UserProfileController>(
      builder: (profile) {
        if (profile.isLoading) return const CircularProgressIndicator();

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  onChanged: () {
                    formKey.currentState?.save();
                    formKey.currentState?.fields['first_name']
                        ?.validate(focusOnInvalid: false);
                    formKey.currentState?.fields['last_name']
                        ?.validate(focusOnInvalid: false);
                    formKey.currentState?.fields['address']
                        ?.validate(focusOnInvalid: false);

                    controller.setFirstName =
                        formKey.currentState?.fields['first_name']?.value ?? '';
                    controller.setMiddleName =
                        formKey.currentState?.fields['middle_name']?.value ??
                            '';
                    controller.setLastName =
                        formKey.currentState?.fields['last_name']?.value ?? '';
                    controller.setAddress =
                        formKey.currentState?.fields['address']?.value ?? '';
                    controller.setBirthday =
                        formKey.currentState?.fields['birthday']?.value;

                    controller.setButtonEnabled =
                        formKey.currentState?.isValid ?? false;
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        name: 'first_name',
                        label: 'First Name',
                        initialValue: profile.firstName,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 26),
                      InputField(
                        name: 'middle_name',
                        label: 'Middle Name',
                        initialValue: profile.middleName,
                      ),
                      const SizedBox(height: 26),
                      InputField(
                        name: 'last_name',
                        label: 'Last Name',
                        initialValue: profile.lastName,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 26),
                      InputField(
                        name: 'email',
                        validator: FormBuilderValidators.email(),
                        label: 'Email',
                        inputType: TextInputType.emailAddress,
                        enabled: false,
                        initialValue: profile.email,
                      ),
                      const SizedBox(height: 26),
                      InputField(
                        name: 'user_name',
                        label: 'Username',
                        enabled: false,
                        initialValue: profile.userName,
                      ),
                      const SizedBox(height: 26),
                      InputField(
                        name: 'address',
                        label: 'Address',
                        initialValue: profile.address,
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 26),
                      DatePickerField(
                        name: 'birthday',
                        labelText: 'Birthday',
                        initialValue: profile.birthday,
                        lastDate: DateTime.now(),
                      ),
                      const SizedBox(height: 26),
                      Padding(
                        padding: const EdgeInsets.only(top: 33),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                // TODO: Implement using Getx
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
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 50,
                              ),
                              onPressed: onSubmit,
                              enabled: controller.buttonEnabled,
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
      },
    );
  }
}
