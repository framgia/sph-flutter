import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/indicator.dart';
import 'package:frontend/src/controllers/spending_breakdown_controller.dart';
import 'package:frontend/src/enums/transaction_enum.dart';

/*
  A Column widget where transaction data displayed in graph is explained

  @param spendingList: List of SpendingBreakdown to figure out which legends to display
*/

class LegendSection extends StatelessWidget {
  const LegendSection({super.key});

  @override
  Widget build(BuildContext context) {
    final SpendingBreakdownController spendingBreakdownController = Get.find();
    List<Widget> legends = [];

    const transactionTypeToColor = {
      TransactionCategory.FOOD: Color(0xFF0384EA),
      TransactionCategory.TRANSPORTATION: Color(0xFFFEA42C),
      TransactionCategory.BILLS: Color(0xFF8047F6),
      TransactionCategory.SAVINGS: Color(0xFF00D27C),
      TransactionCategory.MISC: Color(0xFFDC4949),
    };

    for (var breakdown in spendingBreakdownController.spendingList) {
      final totalSpentPercentage = ((breakdown.totalTransactionAmount /
              spendingBreakdownController.totalSpent) *
          100);
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
