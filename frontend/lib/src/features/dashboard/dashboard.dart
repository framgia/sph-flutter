import 'package:flutter/material.dart';

import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/models/account.dart';

/*
  This widget displays the dashboard of the application 
  User should see:
   - App logo (top-left)
   - User name (top-right)
   - Account list
*/
class Dashboard extends StatelessWidget {
  Dashboard({
    super.key,
  });

  /* This is the list of accounts pulled from BE */
  /* TODO: This is mock data. Change to actual data in the backend soon */
  final List<Account> accountData = [
    Account(
      userId: 0,
      accountType: 0,
      name: 'Account #1',
    ),
    Account(
      userId: 0,
      accountType: 0,
      name: 'Account #2',
    ),
    Account(
      userId: 0,
      accountType: 0,
      name: 'Account #3',
    ),
    Account(
      userId: 0,
      accountType: 0,
      name: 'Account #4',
    ),
    Account(
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Accounts",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: accountData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == accountData.length) {
                        return const SizedBox(
                          height: 70.0,
                        );
                      }
                      return AccountCard(account: accountData[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
