import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final RxBool _forgotPasswordButtonEnabled = false.obs;

  bool get forgotPasswordButtonEnabled => _forgotPasswordButtonEnabled.value;

  set setForgotPasswordButtonEnabled(bool newValue) =>
      _forgotPasswordButtonEnabled.value = newValue;
}
