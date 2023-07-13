import 'package:frontend/src/services/account_service.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/helper/storage.dart';

class DashboardController extends GetxController {
  final RxList<Account> accounts = <Account>[].obs;

  Future<List<Account>> getUserAccounts() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: StorageKeys.userId.name);
    accounts.value = await AccountService.getUserAccounts(userId: userId!);

    return accounts;
  }
}
