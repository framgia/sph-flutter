import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/helper/user_full_name.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/services/user_service.dart';

class UserProfileController extends GetxController {
  final Rx<User> _user = initialProfileInfo.obs;
  final RxBool _loading = true.obs;
  final RxBool _buttonEnabled = true.obs;

  User get user => _user.value;

  bool get loading => _loading.value;
  set setLoading(bool newValue) => _loading.value = newValue;

  bool get buttonEnabled => _buttonEnabled.value;
  set setButtonEnabled(bool newValue) => _buttonEnabled.value = newValue;

  String get userName => _user.value.userName;

  String get firstName => _user.value.firstName;
  set setFirstName(String newValue) => _user.value.firstName = newValue;

  String get middleName => _user.value.middleName ?? '';
  set setMiddleName(String newValue) => _user.value.middleName = newValue;

  String get lastName => _user.value.lastName;
  set setLastName(String newValue) => _user.value.lastName = newValue;

  String get email => _user.value.email;

  String get address => _user.value.address;
  set setAddress(String newValue) => _user.value.address = newValue;

  DateTime get birthday => _user.value.birthday;
  set setBirthday(DateTime newValue) => _user.value.birthday = newValue;

  Future<void> getUser({String userId = ''}) async {
    User user = await UserService.getUser(userId: userId);
    _user.value = user;
    _loading.value = false;
  }

  Future<dio.Response> updateUserProfile(User user) async {
    final updatedProfile = await UserService.updateUserProfile(user);

    final authUserId = await storage.read(key: StorageKeys.userId.name);

    if (updatedProfile.statusCode == HttpStatus.ok) {
      final userData = User.fromJson(updatedProfile.data['data']);

      if (authUserId == userData.id) {
        final fullName = userFullName(userData);
        await storage.write(key: StorageKeys.fullName.name, value: fullName);
      }
    }

    return updatedProfile;
  }
}
