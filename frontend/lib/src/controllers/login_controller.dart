import 'package:get/get.dart';

import 'package:frontend/src/features/home_screen.dart';
import 'package:frontend/src/services/user_service.dart';

class LoginController extends GetxController {
  final RxBool _withLoginToken = false.obs; // determines if storage has login token
  final RxBool _validLoginToken = false.obs; // determines if login token is still valid 
  final RxBool _checkingLoginToken = false.obs; // state, to know if checking of login token is still ongoing
  final RxBool _loginButtonEnabled = false.obs;

  bool get withLoginToken => _withLoginToken.value;
  bool get validLoginToken => _validLoginToken.value;
  bool get checkingLoginToken => _checkingLoginToken.value;
  bool get loginButtonEnabled => _loginButtonEnabled.value;

  set setLoginButtonEnabled(bool newValue) =>
      _loginButtonEnabled.value = newValue;

  Future<bool> validateLoginToken({bool redirect = false}) async {
    _withLoginToken.value = await UserService.hasLoginToken();

    if (_withLoginToken.value) {
      _checkingLoginToken.value = true;
      _validLoginToken.value = await UserService.checkLoginToken();

      if (_validLoginToken.value && redirect) {
        await Get.to(() => const HomeScreen());
      }

      _checkingLoginToken.value = false;
    }

    return _validLoginToken.value;
  }  
}
