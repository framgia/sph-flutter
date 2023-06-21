import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/models/account.dart';

/*
  This widget displays the dashboard of the application 
  User should see:
   - App logo (top-left)
   - User name (top-right)
   - Account list
*/
class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final homeScreenController = Get.put(HomeScreenController());

  /* This is the list of accounts pulled from BE */
  /* TODO: This is mock data. Change to actual data in the backend soon */
  final List<Account> accountData = [
    Account(
      accountId: 1,
      userId: 0,
      accountType: 0,
      name: 'Account #1',
    ),
    Account(
      accountId: 2,
      userId: 0,
      accountType: 0,
      name: 'Account #2',
    ),
    Account(
      accountId: 3,
      userId: 0,
      accountType: 0,
      name: 'Account #3',
    ),
    Account(
      accountId: 4,
      userId: 0,
      accountType: 0,
      name: 'Account #4',
    ),
    Account(
      accountId: 5,
      userId: 0,
      accountType: 0,
      name: 'Account #5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Accounts",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                itemCount: accountData.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AccountCard(account: accountData[index]);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
