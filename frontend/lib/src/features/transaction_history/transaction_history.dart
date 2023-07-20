import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/src/features/transaction_history/components/transaction_card.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/dropdown.dart';
import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/enums/transaction_enum.dart';

/*
  The page where user can see their transaction history per account.

  @arguments accountId, contains Id to access account details
*/
class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionController controller = Get.put(TransactionController());

    final arguments =
        ModalRoute.of(context)!.settings.arguments as AccountScreenArguments;

    controller.resetFilters(arguments.accountId);

    return FutureBuilder(
      future: controller.getTransactions(accountId: arguments.accountId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        return Column(
          children: [
            Breadcrumb(
              text: 'Transaction History',
              onTap: () {
                dashboardAppNav.currentState?.pushNamed(
                  '/accountDetails',
                  arguments: AccountScreenArguments(arguments.accountId),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 110),
              child: Column(
                children: [
                  Dropdown(
                    labelText: 'Filter transaction by type',
                    items: TransactionType.values
                        .map((type) => type.value)
                        .toList(),
                    selectedValue: controller.selectedTransactionType.value,
                    onChanged: (value) {
                      controller.setSelectedTransactionType =
                          TransactionType.fromValue(value.toString());
                      controller.getTransactions(
                        accountId: arguments.accountId,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Column(
                      children: [
                        DatePickerField(
                          labelText: 'From',
                          name: 'filter_by_date_from',
                          initialValue: controller.selectedTransactionDateFrom,
                          lastDate: controller.selectedTransactionDateTo ??
                              DateTime.now(),
                          onChanged: (value) {
                            controller.setSelectedTransactionDateFrom = value;
                            controller.getTransactions(
                              accountId: arguments.accountId,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        DatePickerField(
                          labelText: 'To',
                          name: 'filter_by_date_to',
                          initialValue: controller.selectedTransactionDateTo,
                          firstDate: controller.selectedTransactionDateFrom,
                          lastDate: DateTime.now(),
                          onChanged: (value) {
                            controller.setSelectedTransactionDateTo = value;
                            controller.getTransactions(
                              accountId: arguments.accountId,
                            );
                          },
                        ),
                        const SizedBox(height: 35),
                        controller.transactionList.isEmpty
                            ? Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'No Transaction Record',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              )
                            : ListView.builder(
                                itemCount: controller.transactionList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return TransactionCard(
                                    transaction:
                                        controller.transactionList[index],
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
