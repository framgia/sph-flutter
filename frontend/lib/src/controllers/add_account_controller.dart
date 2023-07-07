import 'package:get/get.dart';

List<String> accountTypes = ['Savings', 'Salary', 'Deposit'];

class AddAccountController extends GetxController {
  final RxString _selectedAccountType = accountTypes[0].obs;
  final RxBool _buttonEnabled = false.obs;

  String get selectedAccountType => _selectedAccountType.value;
  set setSelectedAccountType(String newValue) =>
      _selectedAccountType.value = newValue;

  bool get buttonEnabled => _buttonEnabled.value;
  set setButtonEnabled(bool newValue) => _buttonEnabled.value = newValue;
}
