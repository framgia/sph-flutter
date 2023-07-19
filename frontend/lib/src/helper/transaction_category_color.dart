import 'package:flutter/material.dart';

import 'package:frontend/src/enums/transaction_enum.dart';

/*
  Use to get the Transaction Category icon, particularly Expenses/Withdrawal

  @param transactionCategories: to get the specific icon
*/

Color transactionCategoryColor(TransactionCategory transactionCategories) {
  switch (transactionCategories) {
    case TransactionCategory.FOOD:
      return const Color(0xFF0384EA);
    case TransactionCategory.TRANSPORTATION:
      return const Color(0xFFFEA42C);
    case TransactionCategory.BILLS:
      return const Color(0xFF8047F6);
    case TransactionCategory.SAVINGS:
      return const Color(0xFF00D27C);
    default:
      return const Color(0xFFDC4949);
  }
}
