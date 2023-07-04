import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/models/user.dart';

class UserService {
  // returns List of User(model) by hitting /users route, non-admin users only
  static Future<List<User>> getUsers({String keyword = ''}) async {
    final usersResponse =
        await NetworkConfig().client.get('$usersUrl?keyword=$keyword');

    if (usersResponse.statusCode == HttpStatus.ok) {
      final Iterable data = usersResponse.data['data'];
      List<User> users =
          List<User>.from(data.map((user) => User.fromJson(user)));

      return users;
    } else {
      return [];
    }
  }

  // returns bool, checks if storage has login token
  static Future<bool> hasLoginToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: StorageKeys.loginToken.name);

    return token != null;
  }

  // returns bool, checks if login token is still valid by hitting /user
  static Future<bool> checkLoginToken() async {
    final client = NetworkConfig().client;

    final userResponse = await client.get(userUrl);

    return userResponse.statusCode == HttpStatus.ok;
  }
}
