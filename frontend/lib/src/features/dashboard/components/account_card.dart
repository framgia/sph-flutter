import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/transaction_component/transaction_component.dart';
import 'package:frontend/src/features/dashboard/components/account_card_button.dart';
import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/controllers/account_details_controller.dart';

/*
  Card widget used in dashboard.dart
  Data from an Account class is passed here then is displayed
*/

class AccountCard extends StatelessWidget {
  const AccountCard({Key? key, required this.account}) : super(key: key);

  final Account account;
  static final currencyFormat = NumberFormat(',#00.00');

  @override
  Widget build(BuildContext context) {
    final AccountDetailsController controller =
        Get.put(AccountDetailsController());

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            dashboardAppNav.currentState?.pushNamed(
              '/accountDetails',
              arguments: AccountScreenArguments(account.id!),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.accountName,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "Account Number: ${account.accountNumber?.substring(7)}",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Balance",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "${currencyFormat.format(account.balance)} Php",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AccountCardButton(
                        text: 'Deposit',
                        backgroundColor: const Color(0xFFF66868),
                        onClick: () {
                          Get.bottomSheet(
                            TransactionComponent(
                              label: 'Deposit Cash',
                              accountId: account.id!,
                              balance: account.balance!,
                            ),
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      AccountCardButton(
                        text: 'Withdraw',
                        backgroundColor: const Color(0xFF44AE00),
                        onClick: () {
                          Get.bottomSheet(
                            TransactionComponent(
                              label: 'Withdraw Cash',
                              type: TransactionType.CREDIT,
                              accountId: account.id!,
                              balance: account.balance!,
                            ),
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      AccountCardButton(
                        text: 'Transfer',
                        backgroundColor: const Color(0xFFC106C5),
                        onClick: () {
                          controller.setAccount = account;
                          Get.bottomSheet(
                            TransactionComponent(
                              label: 'Transfer Cash',
                              type: TransactionType.TRANSFER,
                              accountId: account.id!,
                              balance: account.balance!,
                            ),
                            backgroundColor: Colors.white,
                            isScrollControlled: true,
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountScreenArguments {
  final String accountId;

  AccountScreenArguments(this.accountId);
}
