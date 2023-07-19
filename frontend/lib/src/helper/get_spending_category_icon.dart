import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/src/enums/transaction_enum.dart';

/*
  Use to get the Transaction Category icon, particularly Expenses/Withdrawal

  @param transactionCategories: to get the specific icon
*/

Widget getSpendingCategoryIcon(TransactionCategory transactionCategory) {
  switch (transactionCategory) {
    case TransactionCategory.FOOD:
      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF0384EA),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('assets/svg/food.svg'),
      );
    case TransactionCategory.TRANSPORTATION:
      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFFEA42C),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('assets/svg/transportation.svg'),
      );
    case TransactionCategory.BILLS:
      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF8047F6),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('assets/svg/bills.svg'),
      );
    case TransactionCategory.SAVINGS:
      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF00D27C),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('assets/svg/savings.svg'),
      );
    default:
      return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFDC4949),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset('assets/svg/miscellaneous.svg'),
      );
  }
}
