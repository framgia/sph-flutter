import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/controllers/account_details_controller.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/components/transaction_component/transaction_component.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/button.dart';
import 'package:frontend/src/components/balance_card.dart';
import 'package:frontend/src/components/graph.dart';
import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/enums/transaction_enum.dart';

/*
  The page where user can see their account details.
*/

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({super.key});

  static final currencyFormat = NumberFormat(',#00.00');

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    AccountDetailsController controller = Get.put(AccountDetailsController());
    HomeScreenController homeScreenController = Get.find();

    return FutureBuilder(
      future: controller.getUserAccount(accountId: arguments.accountId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              Breadcrumb(
                text: 'Account Details',
                onTap: () {
                  // show the floating button again
                  homeScreenController.floatingActionButtonVisible = true;

                  return dashboardAppNav.currentState?.popUntil((route) {
                    return route.isFirst;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                child: BalanceCard(
                  content: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 21,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              "Balance",
                              style: TextStyle(
                                color: Color(0xFF6D7881),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Obx(
                              () => Text(
                                "PHP ${currencyFormat.format(controller.account.balance)}",
                                style: const TextStyle(
                                  color: Color(0xFF6D7881),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: "Deposite",
                          withShadow: false,
                          buttonColor: const Color(0xFFF66868),
                          padding: const EdgeInsets.all(10),
                          size: const Size(110, 90),
                          radius: 8,
                          onPressed: () {
                            Get.bottomSheet(
                              TransactionComponent(
                                label: 'Deposit Cash',
                                type: TransactionTypes.DEPT,
                                accountId: arguments.accountId,
                                balance: controller.account.balance,
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Button(
                          text: "Withdraw",
                          buttonColor: const Color(0xFF44AE00),
                          withShadow: false,
                          padding: const EdgeInsets.all(10),
                          size: const Size(110, 90),
                          radius: 8,
                          onPressed: () {
                            Get.bottomSheet(
                              TransactionComponent(
                                label: 'Withdraw Cash',
                                type: TransactionTypes.CREDIT,
                                accountId: arguments.accountId,
                                balance: controller.account.balance,
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: "Transfer",
                          withShadow: false,
                          buttonColor: const Color(0xFFC106C5),
                          padding: const EdgeInsets.all(10),
                          size: const Size(110, 90),
                          radius: 8,
                          onPressed: () {
                            Get.bottomSheet(
                              TransactionComponent(
                                label: 'Transfer Cash',
                                type: TransactionTypes.TRANSFER,
                                accountId: arguments.accountId,
                                balance: controller.account.balance,
                              ),
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                            );
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Button(
                          text: "Transaction",
                          withShadow: false,
                          buttonColor: const Color(0xFF1E2E82),
                          padding: const EdgeInsets.all(10),
                          size: const Size(110, 90),
                          radius: 8,
                          onPressed: () {
                            dashboardAppNav.currentState?.pushNamed(
                              '/transactionHistory',
                              arguments: ScreenArguments(arguments.accountId),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 25, 20),
                child: Graph(),
              )
            ],
          ),
        );
      },
    );
  }
}
