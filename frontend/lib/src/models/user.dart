// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String id;
    String userName;
    int isAdmin;
    String firstName;
    String lastName;
    dynamic middleName;
    String email;
    String address;
    DateTime birthday;
    dynamic deletedAt;
    DateTime createdAt;
    DateTime updatedAt;

    User({
        required this.id,
        required this.userName,
        required this.isAdmin,
        required this.firstName,
        required this.lastName,
        this.middleName,
        required this.email,
        required this.address,
        required this.birthday,
        this.deletedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userName: json["user_name"],
        isAdmin: json["is_admin"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        middleName: json["middle_name"],
        email: json["email"],
        address: json["address"],
        birthday: DateTime.parse(json["birthday"]),
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "is_admin": isAdmin,
        "first_name": firstName,
        "last_name": lastName,
        "middle_name": middleName,
        "email": email,
        "address": address,
        "birthday": birthday.toIso8601String(),
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
