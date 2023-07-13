import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/services/transaction_service.dart';

class TransactionController extends GetxController {
  final Rx<TransactionTypes> _selectedTransactionType =
      TransactionTypes.CREDIT.obs;
  final Rx<TransactionCategories> _selectedTransactionCategory =
      TransactionCategories.FOOD.obs;
  final Rx<DateTime> _selectedTransactionDate = DateTime.now().obs;
  final RxBool _transactionSubmitEnabled = false.obs;
  RxList<Transaction> transactionList = <Transaction>[].obs;

  TransactionTypes get selectedTransactionType =>
      _selectedTransactionType.value;

  TransactionCategories get selectedTransactionCategory =>
      _selectedTransactionCategory.value;

  bool get transactionSubmitEnabled => _transactionSubmitEnabled.value;

  DateTime get selectedTransactionDate => _selectedTransactionDate.value;

  set setSelectedTransactionType(TransactionTypes newValue) =>
      _selectedTransactionType.value = newValue;

  set setSelectedTransactionCategory(TransactionCategories newValue) =>
      _selectedTransactionCategory.value = newValue;

  set setSelectedTransactionDate(DateTime newValue) =>
      _selectedTransactionDate.value = newValue;

  set setTransactionSubmitEnabled(bool newValue) =>
      _transactionSubmitEnabled.value = newValue;

  Future<List<Transaction>> getTransactions({String accountId = ''}) async {
    final result =
        await TransactionService.getTransactions(accountId: accountId);
    transactionList.assignAll(result);
    return result;
  }

  Future<dio.Response> postTransaction(
    Transaction transaction,
    String accountId,
    String accountNumber,
  ) async {
    return await TransactionService.postTransaction(
      transaction,
      accountId,
      accountNumber,
    );
  }
}
