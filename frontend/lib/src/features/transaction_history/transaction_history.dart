import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/features/transaction_history/components/transaction_card.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/dropdown.dart';
import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/helper/capitalize_first_letter.dart';

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
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

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
                  arguments: ScreenArguments(arguments.accountId),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 110),
              child: Obx(
                () => Column(
                  children: [
                    Dropdown(
                      labelText: 'Filter transaction by type',
                      items: TransactionTypes.values
                          .map((type) => capitalizeFirstLetter(type.name))
                          .toList(),
                      selectedValue: capitalizeFirstLetter(
                        controller.selectedTransactionType.name,
                      ),
                      onChanged: (value) {
                        controller.setSelectedTransactionType =
                            TransactionTypes.values.firstWhere(
                          (type) => capitalizeFirstLetter(type.name) == value,
                        );
                        debugPrint(
                          controller.selectedTransactionType.name,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    DatePickerField(
                      labelText: 'Filter transaction by date',
                      name: 'filter_by_date',
                      initialValue: controller.selectedTransactionDate,
                      lastDate: DateTime.now(),
                      onChanged: (value) {
                        controller.setSelectedTransactionDate = value!;
                        final formattedDate = DateFormat.yMd().format(value);
                        debugPrint(formattedDate);
                      },
                    ),
                    const SizedBox(height: 35),
                    if (controller.transactionList.isEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          'No Transaction Record',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: controller.transactionList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return TransactionCard(
                            transaction: controller.transactionList[index],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
