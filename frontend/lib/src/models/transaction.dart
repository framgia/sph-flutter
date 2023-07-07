import 'dart:convert';
import 'dart:ffi';
import 'package:intl/intl.dart';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

// ignore_for_file: constant_identifier_names
enum TransactionTypes { CREDIT, DEPT, TRANSFER }

enum Category { SAVINGS, SALARY, BILLS, SENDER, RECIPIENT }

class Transaction {
  String transactionId;
  DateTime transactionDate;
  TransactionTypes transactionType;
  Category category;
  double amount;
  String description;
  String? participantName;

  Transaction({
    required this.transactionId,
    required this.transactionDate,
    required this.transactionType,
    required this.category,
    required this.amount,
    required this.description,
    this.participantName,
  });

  // DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(json["created_at"]),
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json['id'],
        transactionDate:
            DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(json["created_at"]),
        transactionType: json['transaction_type'],
        category: json['category'],
        amount: (json["transaction_amount"] as num).toDouble(),
        description: json["description"],
        participantName: json["account_name"],
      );

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "date": transactionDate,
        "transaction_type": transactionType,
        "category": category,
        "amount": amount,
        "description": description,
        "participantName": participantName
      };
  String generateDescription() {
    if (transactionType == TransactionTypes.DEPT) {
      return 'Deposited money from';
    }

    if (transactionType == TransactionTypes.CREDIT) {
      return 'Deducted money from';
    }

    if (transactionType == TransactionTypes.TRANSFER) {
      if (category == Category.SENDER) {
        return 'Transferred money to';
      }
      return 'Transferred money from';
    }
    return '';
  }
}
