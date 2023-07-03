import 'dart:io';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/models/user.dart';

class UserService {
  static Future<List<User>> getUsers() async {
    final usersResponse = await NetworkConfig().client.get(usersUrl);

    if (usersResponse.statusCode == HttpStatus.ok) {
      final Iterable data = usersResponse.data['data'];
      List<User> users =
          List<User>.from(data.map((user) => User.fromJson(user)));

      return users;
    } else {
      return [];
    }
  }
}
