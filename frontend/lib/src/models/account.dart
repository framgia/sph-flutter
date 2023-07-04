// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
    String id;
    String userId;
    int accountType;
    int balance;

    Account({
        required this.id,
        required this.userId,
        required this.accountType,
        required this.balance,
    });

    factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"],
        userId: json["user_id"],
        accountType: json["account_type"],
        balance: json["balance"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "account_type": accountType,
        "balance": balance,
    };
}
