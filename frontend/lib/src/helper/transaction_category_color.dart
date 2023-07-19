import 'package:flutter/material.dart';

import 'package:frontend/src/enums/transaction_enum.dart';

/*
  Use to get the Transaction Category icon, particularly Expenses/Withdrawal

  @param transactionCategories: to get the specific icon
*/

Color transactionCategoryColor(TransactionCategories transactionCategories) {
  switch (transactionCategories) {
    case TransactionCategories.FOOD:
      return const Color(0xFF0384EA);
    case TransactionCategories.TRANSPORTATION:
      return const Color(0xFFFEA42C);
    case TransactionCategories.BILLS:
      return const Color(0xFF8047F6);
    case TransactionCategories.SAVINGS:
      return const Color(0xFF00D27C);
    default:
      return const Color(0xFFDC4949);
  }
}
