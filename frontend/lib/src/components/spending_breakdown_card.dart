import 'package:flutter/material.dart';

import 'package:frontend/src/models/spendingBreakdown.dart';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/helper/capitalize_first_letter.dart';
import 'package:frontend/src/helper/get_spending_category_icon.dart';

/*
  A Spending Breakdown Card widget where you can display breakdown information with static design of the card.

  @param spendingbreakdown, SpendingBreakdown type variable that holds the breakdown information
*/

class SpendingBreakdownCard extends StatelessWidget {
  const SpendingBreakdownCard({super.key, required this.spendingbreakdown});

  final SpendingBreakdown spendingbreakdown;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            getSpendingCategoryIcon(spendingbreakdown.category),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  spendingbreakdown.category.value,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF6D7881),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Cash',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF6D7881),
                      ),
                )
              ],
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '- PHP ${spendingbreakdown.totalTransactionAmount}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color(0xFFFF0000),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              capitalizeFirstLetter(spendingbreakdown.diffForHumans),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color(0xFF6D7881),
                  ),
            )
          ],
        )
      ],
    );
  }
}
