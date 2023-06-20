import 'dart:convert';

Transaction transactionFromJson(String str) => Transaction.fromJson(json.decode(str));

String transactionToJson(Transaction data) => json.encode(data.toJson());

class Transaction {
  String name;
  String date;
  String amount;
  String description;

  Transaction({
    required this.name,
    required this.date,
    required this.amount,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        name: json["name"],
        date: json["date"],
        amount: json["amount"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "amount": amount,
        "description": description,
      };
}
