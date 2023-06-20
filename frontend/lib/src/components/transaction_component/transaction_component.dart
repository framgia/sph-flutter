import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';

/*
  Reusable transaction component for deposit, withdraw, and transfer cash

  @param label: String value to display what kind of transaction it is,
    basically something like a title.

  @param type: String value representing the type of transaction: DEPOSIT, WITHDRAWAL, or TRANSFER.
    Determines the fields to display and the validation logic.
*/

class TransactionComponent extends StatelessWidget {
  const TransactionComponent({
    Key? key,
    required this.label,
    this.type = 'DEPOSIT',
  }) : super(key: key);

  final String label;
  final String type;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    void onSubmit() {
      if (formKey.currentState?.isValid ?? false) {
        final emailValue = formKey.currentState?.fields['email']?.value;
        final amountValue = formKey.currentState?.fields['amount']?.value;

        // if field is null, do not execute Get.back();
        if ((type == 'TRANSFER' &&
                (emailValue == null || amountValue == null)) ||
            (type == 'DEPOSIT' && amountValue == null)) {
          showAlertDialog(
            title: 'Invalid Input',
            content: 'Please make sure to fill out the field',
          );

          return;
        }

        Get.back();
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
      child: SizedBox(
        height: 400,
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
                InputField(
                  name: 'email',
                  label: 'Email',
                  validator: FormBuilderValidators.email(),
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
