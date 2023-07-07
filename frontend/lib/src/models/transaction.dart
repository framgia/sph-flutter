import 'dart:convert';

Transaction transactionFromJson(String str) =>
    Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

// ignore_for_file: constant_identifier_names
enum TransactionTypes { CREDIT, DEPT, TRANSFER }

enum Category { SAVINGS, SALARY, BILLS, SENDER, RECIPIENT }

class Transaction {
  String? name;
  String? date;
  String amount;
  String description;
  TransactionTypes transactionType;
  Category category;

  Transaction({
    this.name,
    this.date,
    required this.amount,
    required this.description,
    required this.transactionType,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        name: json["name"],
        date: json["date"],
        amount: json["amount"],
        description: json["description"],
        transactionType: json["transaction_type"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "amount": amount,
        "description": description,
        "transaction_type": transactionType,
        "category": category
      };
}
