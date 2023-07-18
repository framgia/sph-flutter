import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/snackbar/show_snackbar.dart';
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

  // returns void, if user successfully deleted, show snackbar with success message.
  static Future<void> deleteUser(String id) async {
    try {
      final response = await NetworkConfig().client.delete('$usersUrl/$id');

      if (response.statusCode == HttpStatus.ok) {
        final data = await response.data['data'];

        showSnackbar(
          title: 'Success',
          content: data['message'],
        );
      } else {
        final error = jsonDecode(response.data.toString());

        showSnackbar(
          title: 'Error',
          content: error['message'],
        );
      }
    } catch (e) {
      showSnackbar(
        title: 'Error',
        content: e.toString(),
      );
    }
  }

  static Future<User> getUser({String userId = ''}) async {
    final authUserId = await storage.read(key: StorageKeys.userId.name);

    final profileUserId = userId.isEmpty ? authUserId : userId;

    final userResponse =
        await NetworkConfig().client.get('$usersUrl/$profileUserId');

    if (userResponse.statusCode == HttpStatus.ok) {
      final data = userResponse.data['data'];
      User user = User.fromJson(data);

      return user;
    } else {
      return initialProfileInfo;
    }
  }

  static Future<Response> updateUserProfile(User userInfo) async {
    final response = await NetworkConfig().client.put(
          '$usersUrl/${userInfo.id}',
          data: userToJson(userInfo),
        );

    return response;
  }
}
