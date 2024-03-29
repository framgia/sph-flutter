import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/balance_card.dart';
import 'package:frontend/src/components/graph.dart';
import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/components/input/dropdown.dart';
import 'package:frontend/src/const/spending_breakdown_filter.dart';
import 'package:frontend/src/controllers/spending_breakdown_controller.dart';
import 'package:frontend/src/components/spending_breakdown_card.dart';

/*
  The page where user can see their spending breakdown.
*/

class SpendingBreakdownPage extends StatelessWidget {
  const SpendingBreakdownPage({super.key});

  static final currencyFormat = NumberFormat(',#00.00');

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as AccountScreenArguments;
    SpendingBreakdownController controller =
        Get.put(SpendingBreakdownController());

    controller.resetFilters();

    return FutureBuilder(
      future: controller.getSpendingBreakdown(accountId: arguments.accountId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              Breadcrumb(
                text: 'Spending Breakdown',
                onTap: () {
                  // show the floating button again
                  dashboardAppNav.currentState?.pushNamed(
                    '/accountDetails',
                    arguments: AccountScreenArguments(arguments.accountId),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                child: BalanceCard(
                  content: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Expenses",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: const Color(0xFF6D7881),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Obx(
                              () => Text(
                                "- PHP ${currencyFormat.format(controller.totalSpent)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: const Color(0xFFFF0000),
                                    ),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 140,
                          child: Dropdown(
                            items: breakdownFilters
                                .map((day) => day.days)
                                .toList(),
                            selectedValue:
                                controller.selectedBreakdownFilter.days,
                            onChanged: (value) {
                              controller.setSelectedBreakdownFilter =
                                  breakdownFilters.firstWhere(
                                (filter) => filter.days == value,
                              );
                              controller.getSpendingBreakdown(
                                accountId: arguments.accountId,
                                days: controller.selectedBreakdownFilter.value,
                              );
                            },
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6D7881),
                              fontWeight: FontWeight.normal,
                            ),
                            height: 22,
                            iconSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                child: Graph(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: const Color(0xFF6D7881),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () {
                          if (controller.spendingList.isEmpty) {
                            return SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No Data Found",
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: controller.spendingList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SpendingBreakdownCard(
                                    spendingbreakdown:
                                        controller.spendingList[index],
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                    color: Color(0xFF6D7881),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
