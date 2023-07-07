import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';
import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';

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
    this.type = TransactionTypes.DEPT,
    required this.accountId,
  }) : super(key: key);

  final String label;
  final TransactionTypes type;
  final String accountId;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final DashboardController dashboardController = Get.find();
    final TransactionController transactionController =
        Get.put(TransactionController());

    void alertDialog({String? title, String? content}) => showAlertDialog(
          title: title ?? 'Invalid Input',
          content: content ?? 'Please make sure to fill out the field',
        );

    void onSubmit() async {
      if (formKey.currentState?.isValid ?? false) {
        final emailValue = formKey.currentState?.fields['email']?.value;
        final amountValue = formKey.currentState?.fields['amount']?.value;
        final descriptionValue =
            formKey.currentState?.fields['description']?.value;
        // Manually set category for now as there is no plan for this feature as of now
        final Map<TransactionTypes, Map<String, dynamic>> typeTexts = {
          TransactionTypes.CREDIT: {
            'category': Category.BILLS,
            'success': 'withdrawn'
          },
        };

        // If field is null, do not execute Get.back();
        if (amountValue == null ||
            descriptionValue == null ||
            ((type == TransactionTypes.TRANSFER) && (emailValue == null))) {
          alertDialog();

          return;
        }
        final transaction = Transaction(
          amount: amountValue,
          description: descriptionValue,
          transactionType: type,
          category: typeTexts[type]!['category'],
        );

        final transactionResponse =
            await transactionController.postTransaction(transaction, accountId);

        if (transactionResponse == true) {
          final success = typeTexts[type]?['success'];

          dashboardController.getUserAccounts();
          transactionController.setTransactionSubmitEnabled = false;

          Get.back();

          alertDialog(
            title: 'Success',
            content: 'You have successfully $success ₱$amountValue.',
          );
        } else if (transactionResponse.runtimeType == String) {
          alertDialog(content: transactionResponse);
        } else {
          alertDialog();
        }

        return;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
      child: SizedBox(
        height: 450,
        child: GetX<TransactionController>(
          builder: (_) => FormBuilder(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            onChanged: () {
              formKey.currentState!.save();

              // Fields required for each type
              final Map<TransactionTypes, List<String>> requiredFields = {
                TransactionTypes.CREDIT: ['amount', 'description'],
              };

              // Enable submit button once requirements are met
              final validFields = requiredFields[type]
                  ?.where(
                    (field) => formKey.currentState!.fields[field]!.isValid,
                  )
                  .toList();

              transactionController.setTransactionSubmitEnabled =
                  requiredFields[type]?.length == validFields?.length;
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
                if (type == TransactionTypes.TRANSFER) ...[
                  InputField(
                    name: 'email',
                    label: 'Email',
                    inputType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.email(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
                InputField(
                  name: 'amount',
                  label: 'Amount',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.required(),
                    ],
                  ),
                  inputType: TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  name: 'description',
                  label: 'Description',
                  inputType: TextInputType.text,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      text: 'Confirm',
                      onPressed: transactionController.transactionSubmitEnabled
                          ? onSubmit
                          : null,
                      buttonColor:
                          transactionController.transactionSubmitEnabled
                              ? const Color(0xFF00CCFF)
                              : Colors.grey,
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
      ),
    );
  }
}
