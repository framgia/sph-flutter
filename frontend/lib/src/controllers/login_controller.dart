import 'package:get/get.dart';

class LoginController extends GetxController {
  final RxBool _loginButtonEnabled = false.obs;

  bool get loginButtonEnabled => _loginButtonEnabled.value;

  set setLoginButtonEnabled(bool newValue) =>
      _loginButtonEnabled.value = newValue;
}
