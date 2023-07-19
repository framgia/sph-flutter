import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/components/input/dropdown.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/controllers/account_details_controller.dart';
import 'package:frontend/src/enums/transaction_enum.dart';

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
      TransactionTypes.DEPT: ['amount'],
      TransactionTypes.TRANSFER: [
        'amount',
        'recipientAccountNumber',
        'accountName',
        'description'
      ]
    };

    final Map<TransactionTypes, String> typeSuccessVerb = {
      TransactionTypes.CREDIT: 'withdrawn',
      TransactionTypes.DEPT: 'deposited',
      TransactionTypes.TRANSFER: 'transferred',
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

        if (type == TransactionTypes.TRANSFER) {
          if (recipientAccountNumber.length != 11) {
            alertDialog(
              content: 'Account number must be 11 digits.',
            );

            return;
          } else if (recipientAccountNumber ==
              accountDetailsController.account.accountNumber) {
            alertDialog(
              content: 'Transferring to same account is not acceptable.',
            );

            return;
          }
        }

        final transaction = Transaction(
          amount: double.parse(amountValue),
          description: descriptionValue ?? 'Deposit',
          transactionType: type,
          category: transactionController.selectedTransactionCategory,
          accountName: accountNameValue ?? '',
        );

        final transactionResponse = await transactionController.postTransaction(
          transaction,
          accountId,
          recipientAccountNumber ?? '',
        );

        if ((transactionResponse.statusCode == HttpStatus.created)) {
          final success = typeSuccessVerb[type];

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

    if (type == TransactionTypes.DEPT) {
      transactionController.setSelectedTransactionCategory =
          TransactionCategories.SAVINGS;
    } else if (type == TransactionTypes.TRANSFER) {
      transactionController.setSelectedTransactionCategory =
          TransactionCategories.SENDER;
    } else if (type == TransactionTypes.CREDIT) {
      transactionController.setSelectedTransactionCategory =
          TransactionCategories.FOOD;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
      child: SizedBox(
        height: type == TransactionTypes.TRANSFER ? 650 : 450,
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
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  InputField(
                    name: 'accountName',
                    label: 'Recipient\'s Complete Name',
                    inputType: TextInputType.text,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
                if (type == TransactionTypes.CREDIT) ...[
                  Dropdown(
                    labelText: 'Category',
                    items: TransactionCategories.creditCategories,
                    selectedValue:
                        transactionController.selectedTransactionCategory.value,
                    onChanged: (value) {
                      final selectedCategory =
                          TransactionCategories.fromValue(value.toString());
                      transactionController.setSelectedTransactionCategory =
                          selectedCategory;
                      debugPrint(selectedCategory.name);
                    },
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(
                    height: 27,
                  )
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
                if (type != TransactionTypes.DEPT) ...[
                  InputField(
                    name: 'description',
                    label: type == TransactionTypes.TRANSFER
                        ? 'Purpose'
                        : 'Description',
                    inputType: TextInputType.text,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
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
