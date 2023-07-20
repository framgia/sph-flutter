// To parse this JSON data, do
//
//     final spendingBreakdown = spendingBreakdownFromJson(jsonString);

import 'dart:convert';

import 'package:frontend/src/enums/transaction_enum.dart';

SpendingBreakdown spendingBreakdownFromJson(String str) =>
    SpendingBreakdown.fromJson(json.decode(str));

String spendingBreakdownToJson(SpendingBreakdown data) =>
    json.encode(data.toJson());

class SpendingBreakdown {
  String accountId;
  TransactionCategory category;
  double totalStartingBalance;
  double totalTransactionAmount;
  DateTime latestTransactionDate;
  String diffForHumans;

  SpendingBreakdown({
    required this.accountId,
    required this.category,
    required this.totalStartingBalance,
    required this.totalTransactionAmount,
    required this.latestTransactionDate,
    required this.diffForHumans,
  });

  factory SpendingBreakdown.fromJson(Map<String, dynamic> json) =>
      SpendingBreakdown(
        accountId: json["account_id"],
        category: TransactionCategory.fromJson(json["category"]),
        totalStartingBalance:
            (json["total_starting_balance"] as num).toDouble(),
        totalTransactionAmount:
            (json["total_transaction_amount"] as num).toDouble().abs(),
        latestTransactionDate: DateTime.parse(json["latest_transaction_date"]),
        diffForHumans: json["diff_for_humans"],
      );

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "category": category,
        "total_starting_balance": totalStartingBalance,
        "total_transaction_amount": totalTransactionAmount,
        "latest_transaction_date": latestTransactionDate,
        "diff_for_humans": diffForHumans,
      };
}
