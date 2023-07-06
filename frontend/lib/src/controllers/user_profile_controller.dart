import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/helper/user_full_name.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/services/user_service.dart';

class UserProfileController extends GetxController {
  final Rx<User> _user = initialProfileInfo.obs;
  final RxBool loading = true.obs;
  final RxBool _buttonEnabled = true.obs;

  User get user => _user.value;

  bool get isLoading => loading.value;
  set setLoading(bool newValue) => loading.value = newValue;

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

  Future<void> getUser() async {
    User user = await UserService.getUser();
    _user.value = user;
    loading.value = false;
  }

  Future<bool> updateUserProfile(User user) async {
    final updated = await UserService.updateUserProfile(user);
    
    if (updated) {
      const storage = FlutterSecureStorage();
      final fullName = userFullName(user);
      await storage.write(key: StorageKeys.fullName.name, value: fullName);
    }

    return updated;
  }
}
