import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/models/spending_breakdown.dart';

// TODO: will be remove in spending breakdown integration
List<SpendingBreakdown> spendingBreakdownData = [
  SpendingBreakdown(
    accountId: '000000000000',
    category: TransactionCategory.FOOD,
    totalStartingBalance: 1000,
    totalTransactionAmount: 180,
    latestTransactionDate: DateTime.now(),
    diffForHumans: 'Today',
  ),
  SpendingBreakdown(
    accountId: '000000000000',
    category: TransactionCategory.TRANSPORTATION,
    totalStartingBalance: 1000,
    totalTransactionAmount: 1000,
    latestTransactionDate: DateTime.now(),
    diffForHumans: 'Today',
  ),
  SpendingBreakdown(
    accountId: '000000000000',
    category: TransactionCategory.BILLS,
    totalStartingBalance: 1000,
    totalTransactionAmount: 1000,
    latestTransactionDate: DateTime.now(),
    diffForHumans: 'Yesterday',
  ),
  SpendingBreakdown(
    accountId: '000000000000',
    category: TransactionCategory.SAVINGS,
    totalStartingBalance: 1000,
    totalTransactionAmount: 1000,
    latestTransactionDate: DateTime.now(),
    diffForHumans: 'June 2, 2023',
  ),
  SpendingBreakdown(
    accountId: '000000000000',
    category: TransactionCategory.MISC,
    totalStartingBalance: 1000,
    totalTransactionAmount: 1000,
    latestTransactionDate: DateTime.now(),
    diffForHumans: 'May 23, 2023',
  ),
];
