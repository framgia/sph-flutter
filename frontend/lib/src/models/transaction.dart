import 'dart:convert';
import 'package:intl/intl.dart';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

// ignore_for_file: constant_identifier_names
enum TransactionTypes { CREDIT, DEPT, TRANSFER }

enum Category { SAVINGS, SALARY, BILLS, SENDER, RECIPIENT }

class Transaction {
  String? id;
  DateTime? transactionDate;
  TransactionTypes transactionType;
  Category category;
  double amount;
  String description;
  String? accountName;
  String? senderName;
  String? receiverName;

  Transaction({
    this.id,
    this.transactionDate,
    required this.transactionType,
    required this.category,
    required this.amount,
    required this.description,
    this.accountName,
    this.senderName,
    this.receiverName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'],
      transactionDate:
          DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(json["created_at"]),
      transactionType: TransactionTypes.values
          .firstWhere((e) => e.name == json['transaction_type']),
      category: Category.values.firstWhere((e) => e.name == json['category']),
      amount: (json["transaction_amount"] as num).toDouble(),
      description: json["description"],
      accountName: json["account_name"],
      receiverName: json['receiver_name'],
      senderName: json['sender_name']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": transactionDate,
        "transaction_type": transactionType,
        "category": category,
        "amount": amount,
        "description": description,
        "accountName": accountName
      };

  String generateDescription() {
    if (transactionType == TransactionTypes.DEPT) {
      return 'Deposited money to';
    }

    if (transactionType == TransactionTypes.CREDIT) {
      return 'Deducted money from';
    }

    if (transactionType == TransactionTypes.TRANSFER) {
      if (category == Category.SENDER) {
        return 'Transferred money to';
      }
      return 'Received money from';
    }
    return '';
  }
}
