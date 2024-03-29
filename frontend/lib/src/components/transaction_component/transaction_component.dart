import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/components/input/dropdown.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/input/input_field.dart';
import 'package:frontend/src/controllers/account_details_controller.dart';
import 'package:frontend/src/controllers/dashboard_controller.dart';
import 'package:frontend/src/controllers/spending_breakdown_controller.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/helper/dialog/show_alert_dialog.dart';
import 'package:frontend/src/models/transaction.dart';

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
    this.type = TransactionType.DEPT,
    this.balance = 0,
  }) : super(key: key);

  final String label;
  final TransactionType type;
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
    final SpendingBreakdownController breakdownController = Get.find();

    // Fields required for each type
    // TODO: Transfer required fields
    final Map<TransactionType, List<String>> requiredFields = {
      TransactionType.CREDIT: ['amount', 'description'],
      TransactionType.DEPT: ['amount'],
      TransactionType.TRANSFER: [
        'amount',
        'recipientAccountNumber',
        'accountName',
        'description'
      ]
    };

    final Map<TransactionType, String> typeSuccessVerb = {
      TransactionType.CREDIT: 'withdrawn',
      TransactionType.DEPT: 'deposited',
      TransactionType.TRANSFER: 'transferred',
    };

    void alertDialog({String? title, String? content}) => showAlertDialog(
          title: title ?? 'Invalid Input',
          content: content ?? 'Please make sure to fill out the field',
        );

    void onSubmit() async {
      transactionController.setTransactionSubmitEnabled = false;

      if (formKey.currentState?.isValid ?? false) {
        final recipientAccountNumber =
            formKey.currentState?.fields['recipientAccountNumber']?.value;
        final amountValue = formKey.currentState?.fields['amount']?.value;
        final accountNameValue =
            formKey.currentState?.fields['accountName']?.value;
        final descriptionValue =
            formKey.currentState?.fields['description']?.value;

        if (type == TransactionType.TRANSFER) {
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

          breakdownController.getSpendingBreakdown(
            accountId: accountDetailsController.account.id ?? '',
          );
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

    if (type == TransactionType.DEPT) {
      transactionController.setSelectedTransactionCategory =
          TransactionCategory.SAVINGS;
    } else if (type == TransactionType.TRANSFER) {
      transactionController.setSelectedTransactionCategory =
          TransactionCategory.SENDER;
    } else if (type == TransactionType.CREDIT) {
      transactionController.setSelectedTransactionCategory =
          TransactionCategory.FOOD;
    }

    if (Get.isBottomSheetOpen ?? false) {
      transactionController.setTransactionSubmitEnabled = false;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
      child: SizedBox(
        height: type == TransactionType.TRANSFER ? 650 : 450,
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
                if (type == TransactionType.TRANSFER) ...[
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
                if (type == TransactionType.CREDIT) ...[
                  Dropdown(
                    labelText: 'Category',
                    items: TransactionCategory.creditCategories,
                    selectedValue:
                        transactionController.selectedTransactionCategory.value,
                    onChanged: (value) {
                      final selectedCategory =
                          TransactionCategory.fromValue(value.toString());
                      transactionController.setSelectedTransactionCategory =
                          selectedCategory;
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
                      type == TransactionType.DEPT
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
                if (type != TransactionType.DEPT) ...[
                  InputField(
                    name: 'description',
                    label: type == TransactionType.TRANSFER
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
                        transactionController.setTransactionSubmitEnabled =
                            false;
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
