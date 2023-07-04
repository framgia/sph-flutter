import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final RxBool _resetPasswordButtonEnabled = false.obs;
  final RxString _password = ''.obs;
  final RxString _passwordConfirmation = ''.obs;
  final RxString _token = ''.obs;

  bool get resetPasswordButtonEnabled => _resetPasswordButtonEnabled.value;

  set setResetPasswordButtonEnabled(bool newValue) =>
      _resetPasswordButtonEnabled.value = newValue;

  String get password => _password.value;
  set setPassword(String newValue) => _password.value = newValue;

  String get passwordConfirmation => _passwordConfirmation.value;
  set setpasswordConfirmation(String newValue) =>
      _passwordConfirmation.value = newValue;

  String get token => _token.value;
  set setToken(String newValue) => _token.value = newValue;
}
