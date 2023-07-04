import 'package:get/get.dart';

class SignUpController extends GetxController {
  final RxBool _signUpFirstButtonEnabled = false.obs;
  final RxBool _signUpSecondButtonEnabled = false.obs;
  final RxString _password = ''.obs;

  bool get signUpFirstButtonEnabled => _signUpFirstButtonEnabled.value;
  set setSignUpFirstButtonEnabled(bool newValue) =>
      _signUpFirstButtonEnabled.value = newValue;

  bool get signUpSecondButtonEnabled => _signUpSecondButtonEnabled.value;
  set setSignUpSecondButtonEnabled(bool newValue) =>
      _signUpSecondButtonEnabled.value = newValue;

  String get password => _password.value;
  set setPassword(String newValue) => _password.value = newValue;
}
