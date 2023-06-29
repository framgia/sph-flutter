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
    String? token;

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
        this.token,
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
        token: json["token"],
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
        "token": token,
    };
}
