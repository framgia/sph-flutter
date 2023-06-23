import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final RxBool _buttonEnabled = false.obs;
  final RxString _oldPassword = ''.obs;
  final RxString _newPassword = ''.obs;
  final RxString _newPasswordConfirmation = ''.obs;

  bool get buttonEnabled => _buttonEnabled.value;
  set setButtonEnabled(bool newValue) => _buttonEnabled.value = newValue;

  String get oldPassword => _oldPassword.value;
  set setOldPassword(String newValue) => _oldPassword.value = newValue;

  String get newPassword => _newPassword.value;
  set setNewPassword(String newValue) => _newPassword.value = newValue;

  String get newPasswordConfirmation => _newPasswordConfirmation.value;
  set setNewPasswordConfirmation(String newValue) => _newPasswordConfirmation.value = newValue;
}
