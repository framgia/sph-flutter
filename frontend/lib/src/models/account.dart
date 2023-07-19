// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

import 'package:frontend/src/enums/account_enum.dart';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  String? id;
  String? userId;
  AccountType accountType;
  String accountName;
  double? balance;
  String? accountNumber;

  Account({
    this.id,
    this.userId,
    required this.accountType,
    required this.accountName,
    this.balance,
    this.accountNumber,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"],
        userId: json["user_id"],
        accountType: AccountType.fromJson(json['account_type']),
        accountName: json["account_name"],
        balance: json["balance"].toDouble(),
        accountNumber: json["account_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "account_type": accountType.name,
        "account_name": accountName,
        "balance": balance,
        "account_number": accountNumber
      };
}
