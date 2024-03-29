import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:frontend/src/helper/dio.dart';
import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/enums/transaction_enum.dart';

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
    DateTime? from,
    DateTime? to,
    TransactionType? type,
  }) async {
    String strDateFrom =
        DateFormat('yyyy-MM-dd').format(from ?? DateTime.now());
    String strDateTo = DateFormat('yyyy-MM-dd').format(to ?? DateTime.now());
    final url = accountTransactionsUrl.replaceFirst('{id}', accountId);
    final Map<String, dynamic> query = {};

    if (type != TransactionType.ALL) query['type'] = type!.name;
    if (from != null) {
      query['from'] = strDateFrom;
      query['to'] = strDateTo;
    }

    final transactionResponse =
        await NetworkConfig().client.get(url, queryParameters: query);

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
