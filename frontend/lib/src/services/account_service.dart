import 'dart:io';

import 'package:dio/dio.dart';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/models/account.dart';
import 'package:frontend/src/models/spending_breakdown.dart';

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
    final url = userAccountUrl.replaceFirst('{account_id}', accountId);
    final userAccountResponse = await NetworkConfig().client.get(url);

    if (userAccountResponse.statusCode == HttpStatus.ok) {
      return Account.fromJson(userAccountResponse.data['data']);
    } else {
      return null;
    }
  }

  static Future<Response> addUserAccount(Account account) async {
    return await NetworkConfig().client.post(
          accountUrl,
          data: accountToJson(account),
        );
  }

  static Future<List<SpendingBreakdown>> getBreakdown({
    String accountId = '',
    int days = 0,
  }) async {
    final url = accountBreakdownUrl
        .replaceFirst('{id}', accountId)
        .replaceFirst('{days}', days > 0 ? days.toString() : '');
    final accountBreakdownResponse = await NetworkConfig().client.get(url);

    if (accountBreakdownResponse.statusCode == HttpStatus.ok) {
      final Iterable data = accountBreakdownResponse.data['data'];
      final List<SpendingBreakdown> breakdown = List<SpendingBreakdown>.from(
        data.map((category) => SpendingBreakdown.fromJson(category)),
      );

      return breakdown;
    }

    return [];
  }
}
