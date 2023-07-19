import 'dart:convert';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:intl/intl.dart';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  String? id;
  DateTime? transactionDate;
  TransactionType transactionType;
  TransactionCategory category;
  double amount;
  String description;
  String accountName;
  String? senderName;
  String? receiverName;

  Transaction({
    this.id,
    this.transactionDate,
    required this.transactionType,
    required this.category,
    required this.amount,
    required this.description,
    required this.accountName,
    this.senderName,
    this.receiverName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        transactionDate:
            DateFormat('yyyy-MM-ddTHH:mm:ssZ').parseUTC(json["created_at"]),
        transactionType: TransactionType.fromJson(json['transaction_type']),
        category: TransactionCategory.fromJson(json['category']),
        amount: (json["transaction_amount"] as num).toDouble(),
        description: json["description"],
        accountName: json["account_name"],
        receiverName: json['receiver_name'],
        senderName: json['sender_name'],
      );

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
    if (transactionType == TransactionType.DEPT) {
      return 'Deposited money to';
    }

    if (transactionType == TransactionType.CREDIT) {
      return 'Deducted money from';
    }

    if (transactionType == TransactionType.TRANSFER) {
      if (category == TransactionCategory.SENDER) {
        return 'Transferred money to';
      }
      return 'Received money from';
    }
    return '';
  }
}
