import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend/src/controllers/change_password_controller.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';
import 'package:frontend/src/helper/storage.dart';

import 'package:frontend/src/navigators/profile_screen_navigator.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/components/button.dart';
import 'package:get/get.dart';

/*
  The page where user can change their password.
*/
class ProfileChangePassword extends StatelessWidget {
  const ProfileChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    const storage = FlutterSecureStorage();
    final ChangePasswordController controller =
        Get.put(ChangePasswordController());

    onSubmit() async {
      // disable save button to prevent multiple requests
      controller.setButtonEnabled = false;

      final client = NetworkConfig().client;
      // get userId from storage
      final userId = await storage.read(key: StorageKeys.userId.name);

      try {
        final changePasswordResponse = await client.put(
          '$authUrl/$userId',
          data: {
            'old_password': controller.oldPassword,
            'new_password': controller.newPassword,
            'new_password_confirmation': controller.newPasswordConfirmation,
          },
        );

        if (changePasswordResponse.statusCode == HttpStatus.ok) {
          profileAppNav.currentState?.popUntil((route) {
            return route.isFirst;
          });

          showSnackbar(
            title: "Success",
            content: "Changed password successfully.",
          );
        } else if (changePasswordResponse.statusCode == HttpStatus.badRequest) {
          // the error response is in Response<dynamic>, toString + jsonDecode to easily access data
          final error = jsonDecode(changePasswordResponse.data.toString());

          final message = error['error']['message'];
          final oldPasswordError = message['old_password'];
          final newPasswordError = message['new_password'];
          final newPasswordConfirmationError =
              message['new_password_confirmation'];

          if (oldPasswordError.length > 0) {
            formKey.currentState?.fields['old_password']
                ?.invalidate(oldPasswordError[0]);
          }
          if (newPasswordError.length > 0) {
            formKey.currentState?.fields['new_password']
                ?.invalidate(newPasswordError[0]);
          }
          if (newPasswordConfirmationError.length > 0) {
            formKey.currentState?.fields['new_password_confirmation']
                ?.invalidate(newPasswordConfirmationError[0]);
          }
        }
      } catch (e) {
        debugPrint("error catched");
        debugPrint(e.toString());
      }
    }

    return GetX<ChangePasswordController>(
      builder: (_) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                onChanged: () {
                  formKey.currentState?.save();
                  formKey.currentState?.fields['old_password']
                      ?.validate(focusOnInvalid: false);
                  formKey.currentState?.fields['new_password']
                      ?.validate(focusOnInvalid: false);
                  formKey.currentState?.fields['new_password_confirmation']
                      ?.validate(focusOnInvalid: false);

                  controller.setOldPassword =
                      formKey.currentState?.fields['old_password']?.value ?? '';
                  controller.setNewPassword =
                      formKey.currentState?.fields['new_password']?.value ?? '';
                  controller.setNewPasswordConfirmation = formKey.currentState
                          ?.fields['new_password_confirmation']?.value ??
                      '';

                  controller.setButtonEnabled =
                      formKey.currentState?.isValid ?? false;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      name: 'old_password',
                      label: 'Old Password',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    InputField(
                      name: 'new_password',
                      label: 'New Password',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.notEqual(
                          controller.oldPassword,
                          errorText:
                              "New password must be different from the old password.",
                        ),
                      ]),
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    InputField(
                      name: 'new_password_confirmation',
                      label: 'Confrim New Password',
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.equal(
                          controller.newPassword,
                          errorText: "New password does not match.",
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 33),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Button(
                            text: 'Save',
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 50,
                            ),
                            onPressed: onSubmit,
                            enabled: controller.buttonEnabled,
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
