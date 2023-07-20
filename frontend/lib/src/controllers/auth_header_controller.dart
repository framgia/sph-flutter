import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/src/services/user_service.dart';
import 'package:frontend/src/helper/storage.dart';

class AuthHeaderController extends GetxController {
  final RxString _name = ''.obs;
  final RxBool _hasLoginToken = false.obs;

  String get name => _name.value;
  bool get loginToken => _hasLoginToken.value;

  Future<String> getFullName() async {
    const storage = FlutterSecureStorage();
    final fullName = await storage.read(key: StorageKeys.fullName.name);
    _name.value = fullName ?? '';

    return name;
  }

  Future<bool> hasLoginToken() async {
    final bool loginToken = await UserService.hasLoginToken();

    return _hasLoginToken.value = loginToken;
  }
}
