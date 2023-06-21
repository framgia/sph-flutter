// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account {
  int id;
  int userId;
  int accountType;
  String name;

  Account({
    required this.id,
    required this.userId,
    required this.accountType,
    required this.name,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"],
        userId: json["user_id"],
        accountType: json["account_type"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "account_type": accountType,
        "name": name,
      };
}
