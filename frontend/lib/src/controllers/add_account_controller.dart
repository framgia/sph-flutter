import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio;

import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/services/account_service.dart';
import 'package:frontend/src/enums/account_enum.dart';

class AddAccountController extends GetxController {
  final RxString _selectedAccountType = accountTypes[0].obs;
  final RxBool _buttonEnabled = false.obs;

  String get selectedAccountType => _selectedAccountType.value;
  set setSelectedAccountType(String newValue) =>
      _selectedAccountType.value = newValue;

  bool get buttonEnabled => _buttonEnabled.value;
  set setButtonEnabled(bool newValue) => _buttonEnabled.value = newValue;

  Future<dio.Response> addUserAccount(Account account) async {
    return await AccountService.addUserAccount(account);
  }
}
