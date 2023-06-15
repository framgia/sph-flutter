import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/components/account_card.dart';
import 'package:frontend/src/models/account.dart';

class Dashboard extends StatelessWidget {
  Dashboard({
    super.key,
  });

  /* This is the list of accounts pulled from BE */
  /* NOTE: This is currently using mock data */
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/sph-flutter-logo.png'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: FittedBox(
                    child: Text(
                      'REDEMPTO D. LEGASPI III',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              "Dashboard",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(
            "Accounts",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          /* ListView that handles the displaying of all accounts */
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView.builder(
              itemCount: accountData.length,
              itemBuilder: (context, index) =>
                  AccountCard(account: accountData[index]),
            ),
          ),
        ],
      ),
    );
  }
}
