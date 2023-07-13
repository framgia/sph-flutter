import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/input/dropdown.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/controllers/add_account_controller.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/enums/account_enum.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';

/*
  The dialog for adding new account
*/

class AddAccountDialog extends StatelessWidget {
  const AddAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    final AddAccountController controller = Get.put(AddAccountController());
    final DashboardController dashboardController =
        Get.put(DashboardController());

    void onSubmit() async {
      controller.setButtonEnabled = false;

      final accountResponse = await controller.addUserAccount(
        Account(
          accountName: formKey.currentState!.fields['account_name']!.value,
          accountType: AccountType.fromValue(
            controller.selectedAccountType,
          ),
        ),
      );

      if (accountResponse.statusCode == HttpStatus.created) {
        Get.back();

        showSnackbar(
          title: 'Success',
          content: 'You have successfully created an account.',
        );

        await dashboardController.getUserAccounts();
      } else if (accountResponse.statusCode == HttpStatus.badRequest) {
        final error =
            jsonDecode(accountResponse.data.toString())['error']['message'];

        final accountNameError = error['account_name'];

        if (accountNameError != null) {
          formKey.currentState?.fields['account_name']
              ?.invalidate(accountNameError[0]);
        }
      }
    }

    return Dialog(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Account',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(
                        color: Color(0xFF6D7881),
                        Icons.close,
                      ),
                      onPressed: () {
                        controller.setButtonEnabled = false;
                        Get.back();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 28),
                FormBuilder(
                  key: formKey,
                  onChanged: () {
                    formKey.currentState!.save();

                    controller.setButtonEnabled = formKey.currentState!.isValid;

                    formKey.currentState?.fields['account_name']
                        ?.validate(focusOnInvalid: false);
                  },
                  child: Column(
                    children: [
                      Dropdown(
                        labelText: 'Account Type',
                        items: accountTypes,
                        selectedValue: controller.selectedAccountType,
                        onChanged: (value) {
                          controller.setSelectedAccountType = value.toString();
                        },
                      ),
                      const SizedBox(height: 26),
                      InputField(
                        name: 'account_name',
                        label: 'Account Name',
                        validator: FormBuilderValidators.required(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 59),
                Obx(
                  () => Button(
                    text: 'Submit',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    onPressed: onSubmit,
                    enabled: controller.buttonEnabled,
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
