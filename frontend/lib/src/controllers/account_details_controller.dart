import 'package:get/get.dart';

import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/services/account_service.dart';

class AccountDetailsController extends GetxController {
  final Rx<Account> _account = Account(id: '', balance: 0, userId: '', accountType: 0).obs;

  Account get account => _account.value;

  Future<Account?> getUserAccount({String accountId = ''}) async {
    final result = await AccountService.getUserAccount(
      accountId: accountId,
    );

    if (result != null) _account.value = result;

    return result;
  }
}
