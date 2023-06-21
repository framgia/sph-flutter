import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/transaction_component/transaction_component.dart';
import 'package:frontend/src/features/dashboard/components/account_card_button.dart';
import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';

/*
  Card widget used in dashboard.dart
  Data from an Account class is passed here then is displayed
*/

class AccountCard extends StatelessWidget {
  const AccountCard({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
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
              arguments: ScreenArguments(account.accountId),
            );
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Total Deposit: ₱1,000,000",
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                  ),
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
                            const TransactionComponent(
                              label: 'Deposit Cash',
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
                            const TransactionComponent(
                              label: 'Witdraw Cash',
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
                          Get.bottomSheet(
                            const TransactionComponent(
                              label: 'Transfer Cash',
                              type: 'TRANSFER',
                            ),
                            backgroundColor: Colors.white,
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

class ScreenArguments {
  final int accountId;

  ScreenArguments(this.accountId);
}
