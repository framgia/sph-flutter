import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';

/*
  Reusable transaction component for deposit, withdraw, and transfer cash

  @param label: String value to display what kind of transaction it is,
    basically something like a title.

  @param type: String value representing the type of transaction: DEPT, CREDIT, or TRANSFER.
    Determines the fields to display and the validation logic.
    Value should follow the backend enum values.

  @param accountId: String value for the id of the user's account
*/

class TransactionComponent extends StatelessWidget {
  const TransactionComponent({
    Key? key,
    required this.label,
    this.type = 'DEPT',
    required this.accountId,
  }) : super(key: key);

  final String label;
  final String type;
  final String accountId;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final DashboardController controller = Get.put(DashboardController());

    void alertDialog({String? title, String? content}) => showAlertDialog(
          title: title ?? 'Invalid Input',
          content: content ?? 'Please make sure to fill out the field',
        );

    void onSubmit() async {
      await NetworkConfig().getCsrftoken();
      final client = NetworkConfig().client;

      if (formKey.currentState?.isValid ?? false) {
        final receiverValue =
            formKey.currentState?.fields['receiver_id']?.value;
        final amountValue = formKey.currentState?.fields['amount']?.value;
        final descriptionValue =
            formKey.currentState?.fields['description']?.value;
        // Manually set category for now as there is no plan for this feature as of now
        // TODO: Deposit and transfer
        final Map typeTexts = {
          'CREDIT': {'category': 'BILLS', 'success': 'withdrawn'},
        };

        // If field is null, do not execute Get.back();
        if (amountValue == null ||
            descriptionValue == null ||
            (type.contains('TRANSFER') && receiverValue == null)) {
          alertDialog();

          return;
        }

        final transactionResponse = await client.post(
          accountTransactionsUrl.replaceFirst('{id}', accountId),
          data: {
            'amount': amountValue,
            'description': descriptionValue,
            'transaction_type': type,
            'category': typeTexts[type]['category'],
            'receiver_id': receiverValue,
          },
        );

        if (transactionResponse.statusCode == HttpStatus.created) {
          final success = typeTexts[type]['success'];

          controller.getUserAccounts();

          Get.back();

          alertDialog(
            title: 'Success',
            content: 'You have successfully $success ₱$amountValue.',
          );
        } else {
          final error = jsonDecode(transactionResponse.data.toString());

          if (error['error']['message'].runtimeType == String) {
            alertDialog(content: error['error']['message']);
            return;
          }

          alertDialog();
          return;
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
      child: SizedBox(
        height: 450,
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          onChanged: () {
            formKey.currentState!.save();
          },
          child: Column(
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 13,
              ),
              if (type == 'TRANSFER') ...[
                const InputField(
                  name: 'receiver_id',
                  label: 'Account id',
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
              InputField(
                name: 'amount',
                label: 'Amount',
                validator: FormBuilderValidators.integer(),
                inputType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              const InputField(
                name: 'description',
                label: 'Description',
                inputType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Button(
                    text: 'Confirm',
                    onPressed: onSubmit,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 38,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 0, 140, 255),
                          ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
