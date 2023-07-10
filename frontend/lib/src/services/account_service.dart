import 'dart:io';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/models/account.dart';

class AccountService {
  static Future<List<Account>> getUserAccounts({String userId = ''}) async {
    final userAccountsResponse = await NetworkConfig()
        .client
        .get(userAccountsUrl.replaceFirst('{id}', userId));

    if (userAccountsResponse.statusCode == HttpStatus.ok) {
      final Iterable data = userAccountsResponse.data['data'];
      final List<Account> userAccounts =
          List<Account>.from(data.map((account) => Account.fromJson(account)));

      return userAccounts;
    } else {
      return [];
    }
  }

  static Future<Account?> getUserAccount({String accountId = ''}) async {
    final url = userAccountUrl
      .replaceFirst('{account_id}', accountId);
    final userAccountResponse = await NetworkConfig().client.get(url);

    if (userAccountResponse.statusCode == HttpStatus.ok) {
      return Account.fromJson(userAccountResponse.data['data']);
    } else {
      return null;
    }
  }
}
