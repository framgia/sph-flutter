import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';
import 'package:frontend/src/controllers/account_details_controller.dart';

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
    required this.accountId,
    this.type = TransactionTypes.DEPT,
    this.balance = 0,
  }) : super(key: key);

  final String label;
  final TransactionTypes type;
  final String accountId;
  final double balance;

  static final currencyFormat = NumberFormat(',#00.00');

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final DashboardController dashboardController = Get.find();
    final AccountDetailsController accountDetailsController =
        Get.put(AccountDetailsController());
    final TransactionController transactionController =
        Get.put(TransactionController());

    // Fields required for each type
    // TODO: Transfer required fields
    final Map<TransactionTypes, List<String>> requiredFields = {
      TransactionTypes.CREDIT: ['amount', 'description'],
      TransactionTypes.DEPT: ['amount', 'description'],
      TransactionTypes.TRANSFER: [
        'amount',
        'recipientAccountNumber',
        'accountName',
        'description'
      ]
    };

    // Manually set category for now as there is no plan for this feature as of now
    // TODO: Transfer type texts
    final Map<TransactionTypes, Map<String, dynamic>> typeTexts = {
      TransactionTypes.CREDIT: {
        'category': Category.BILLS,
        'success': 'withdrawn'
      },
      TransactionTypes.DEPT: {
        'category': Category.SAVINGS,
        'success': 'deposited',
      },
      TransactionTypes.TRANSFER: {
        'category': Category.SENDER,
        'success': 'transfered'
      },
    };

    void alertDialog({String? title, String? content}) => showAlertDialog(
          title: title ?? 'Invalid Input',
          content: content ?? 'Please make sure to fill out the field',
        );

    void onSubmit() async {
      if (formKey.currentState?.isValid ?? false) {
        final recipientAccountNumber =
            formKey.currentState?.fields['recipientAccountNumber']?.value;
        final amountValue = formKey.currentState?.fields['amount']?.value;
        final accountNameValue =
            formKey.currentState?.fields['accountName']?.value;
        final descriptionValue =
            formKey.currentState?.fields['description']?.value;

        if (type == TransactionTypes.TRANSFER &&
            recipientAccountNumber.length != 11) {
          alertDialog(content: 'Account number must be 11 digits.');

          return;
        }

        final transaction = Transaction(
          amount: double.parse(amountValue),
          description: descriptionValue,
          transactionType: type,
          category: typeTexts[type]!['category'],
          accountName: accountNameValue ?? '',
        );

        final transactionResponse = await transactionController.postTransaction(
          transaction,
          accountId,
          recipientAccountNumber ?? '',
        );

        if ((transactionResponse.statusCode == HttpStatus.created)) {
          final success = typeTexts[type]?['success'];

          dashboardController.getUserAccounts();
          accountDetailsController.getUserAccount(accountId: accountId);
          transactionController.setTransactionSubmitEnabled = false;

          Get.back();

          alertDialog(
            title: 'Success',
            content: 'You have successfully $success ₱$amountValue.',
          );
        } else if (transactionResponse.statusCode == HttpStatus.badRequest) {
          final error = jsonDecode(transactionResponse.data.toString())['error']
              ['message'];
          if (error['account'] != null) {
            alertDialog(title: 'Unsuccessful', content: error['account'][0]);
          } else if (error['amount'] != null) {
            alertDialog(
              title: 'Unsuccessful',
              content: error['amount'][0],
            );
          } else {
            alertDialog();
          }
        } else {
          alertDialog();
        }

        return;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
      child: SizedBox(
        height: type == TransactionTypes.TRANSFER ? 600 : 400,
        child: GetX<TransactionController>(
          builder: (_) => FormBuilder(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            onChanged: () {
              formKey.currentState!.save();

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
                      name: 'recipientAccountNumber',
                      label: 'Recipient\'s Account Number',
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.required(),
                          FormBuilderValidators.equalLength(11),
                        ],
                      )),
                  const SizedBox(
                    height: 32,
                  ),
                  InputField(
                    name: 'accountName',
                    label: 'Recipient\'s Name',
                    inputType: TextInputType.text,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
                InputField(
                  name: 'amount',
                  label:
                      'Amount (Balance: ${currencyFormat.format(balance)} Php)',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.required(),
                      type == TransactionTypes.DEPT
                          ? FormBuilderValidators.max(
                              500000,
                              errorText:
                                  "Amount exceeds to deposit limit of 500, 000 Php.",
                            )
                          : FormBuilderValidators.max(
                              balance,
                              errorText:
                                  "Amount exceeds the remaining balance.",
                            ),
                    ],
                  ),
                  inputType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                      onPressed: onSubmit,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 38,
                      ),
                      enabled: transactionController.transactionSubmitEnabled,
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
