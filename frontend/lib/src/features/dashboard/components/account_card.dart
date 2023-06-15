import 'package:flutter/material.dart';
import 'package:frontend/src/features/dashboard/components/account_card_button.dart';
import 'package:frontend/src/models/account.dart';

/*
  Card widget for the account in the account list found in the Dashboard
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
          onTap: () {},
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
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AccountCardButton(
                        text: 'Deposit',
                        backgroundColor: Color(0xFFF66868),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      AccountCardButton(
                        text: 'Withdraw',
                        backgroundColor: Color(0xFF44AE00),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      AccountCardButton(
                        text: 'Transfer',
                        backgroundColor: Color(0xFFC106C5),
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
