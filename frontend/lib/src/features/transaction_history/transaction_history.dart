import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/features/transaction_history/components/transaction_card.dart';
import 'package:frontend/src/features/transaction_history/data/data.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/components/input/date_picker_field.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/dropdown.dart';

/*
  The page where user can see their transaction history per account.
*/
class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = Get.put(TransactionController());
    final homeScreenController = Get.put(HomeScreenController());

    return Column(
      children: [
        Breadcrumb(
          text: 'Transaction History',
          onTap: () {
            homeScreenController.setCurrentDashboardSettingsName = '/dashboard';
            dashboardAppNav.currentState?.popUntil((route) {
              return route.isFirst;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 35, 25, 110),
          child: Obx(
            () => Column(
              children: [
                Dropdown(
                  labelText: 'Filter transaction by type',
                  items: transactionTypes,
                  selectedValue: transactionController.selectedTransactionType,
                  onChanged: (value) {
                    transactionController.setSelectedTransactionType = value.toString();
                    debugPrint(transactionController.selectedTransactionType);
                  },
                ),
                const SizedBox(height: 20),
                DatePickerField(
                  labelText: 'Filter transaction by date',
                  name: 'filter_by_date',
                  initialValue: transactionController.selectedTransactionDate,
                  onChanged: (value) {
                    transactionController.setSelectedTransactionDate = value!;
                    final formattedDate = DateFormat.yMd().format(value);
                    debugPrint(formattedDate);
                  },
                ),
                const SizedBox(height: 35),
                if (transactionData.isEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      'No Transaction Record',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: transactionData.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return TransactionCard(transaction: transactionData[index]);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
