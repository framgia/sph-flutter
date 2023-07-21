import 'package:flutter/material.dart';
import 'package:frontend/src/models/spending_breakdown.dart';

import 'package:frontend/src/components/indicator.dart';
import 'package:frontend/src/enums/transaction_enum.dart';

/*
  A Column widget where transaction data displayed in graph is explained

  @param spendingList: List of SpendingBreakdown to figure out which legends to display
*/

class LegendSection extends StatelessWidget {
  const LegendSection({
    super.key,
    required this.spendingList,
    required this.totalSpent,
  });

  final List<SpendingBreakdown> spendingList;
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    List<Widget> legends = [];

    const transactionTypeToColor = {
      TransactionCategory.FOOD: Color(0xFF0384EA),
      TransactionCategory.TRANSPORTATION: Color(0xFFFEA42C),
      TransactionCategory.BILLS: Color(0xFF8047F6),
      TransactionCategory.SAVINGS: Color(0xFF00D27C),
      TransactionCategory.MISC: Color(0xFFDC4949),
    };

    for (var breakdown in spendingList) {
      final totalSpentPercentage =
          ((breakdown.totalTransactionAmount / totalSpent) * 100);
      final percentageString = totalSpentPercentage.toStringAsFixed(1);

      final color =
          transactionTypeToColor[breakdown.category] ?? const Color(0xFFDC4949);
      final text = (totalSpentPercentage < 7)
          ? '${breakdown.category.value} ($percentageString%)'
          : breakdown.category.value;

      legends.add(
        Indicator(color: color, text: text, isSquare: true),
      );
    }

    legends
        .expand(
          (item) => [
            item,
            const SizedBox(
              height: 4,
            )
          ],
        )
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legends,
    );
  }
}
