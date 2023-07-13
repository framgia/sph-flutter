import 'dart:io';

import 'package:dio/dio.dart';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/models/transaction.dart';

class TransactionService {
  static Future<Response> postTransaction(
    Transaction transaction,
    String accountId,
    String accountNumber,
  ) async {
    final response = await NetworkConfig().client.post(
      accountTransactionsUrl.replaceFirst('{id}', accountId),
      data: {
        'amount': transaction.amount,
        'transaction_type': transaction.transactionType.name,
        'category': transaction.category.name,
        'description': transaction.description,
        'account_number': accountNumber,
        'account_name': transaction.accountName,
      },
    );

    return response;
  }

  static Future<List<Transaction>> getTransactions({
    String accountId = '',
  }) async {
    final url = accountTransactionsUrl.replaceFirst('{id}', accountId);
    final transactionResponse = await NetworkConfig().client.get(url);

    if (transactionResponse.statusCode == HttpStatus.ok) {
      final Iterable data = transactionResponse.data['data'];
      final List<Transaction> transactions = List<Transaction>.from(
        data.map(
          (transaction) => Transaction.fromJson(transaction),
        ),
      );
      return transactions;
    }
    return [];
  }
}
