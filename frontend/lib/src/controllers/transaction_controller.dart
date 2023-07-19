import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/enums/transaction_enum.dart';
import 'package:frontend/src/services/transaction_service.dart';

class TransactionController extends GetxController {
  final Rx<TransactionType> _selectedTransactionType = TransactionType.ALL.obs;
  final Rx<TransactionCategory> _selectedTransactionCategory =
      TransactionCategory.FOOD.obs;
  final Rxn<DateTime> _selectedTransactionDateFrom = Rxn<DateTime>();
  final Rxn<DateTime> _selectedTransactionDateTo = Rxn<DateTime>();
  final RxBool _transactionSubmitEnabled = false.obs;
  RxList<Transaction> transactionList = <Transaction>[].obs;
  TransactionType get selectedTransactionType => _selectedTransactionType.value;

  TransactionCategory get selectedTransactionCategory =>
      _selectedTransactionCategory.value;

  DateTime? get selectedTransactionDateFrom =>
      _selectedTransactionDateFrom.value;

  DateTime? get selectedTransactionDateTo => _selectedTransactionDateTo.value;

  bool get transactionSubmitEnabled => _transactionSubmitEnabled.value;

  set setSelectedTransactionType(TransactionType newValue) =>
      _selectedTransactionType.value = newValue;

  set setSelectedTransactionCategory(TransactionCategory newValue) =>
      _selectedTransactionCategory.value = newValue;

  set setSelectedTransactionDateFrom(DateTime? newValue) =>
      _selectedTransactionDateFrom.value = newValue;

  set setSelectedTransactionDateTo(DateTime? newValue) =>
      _selectedTransactionDateTo.value = newValue;

  set setTransactionSubmitEnabled(bool newValue) =>
      _transactionSubmitEnabled.value = newValue;

  void resetFilters(accountId) {
    setSelectedTransactionType = TransactionType.ALL;
  }

  Future<List<Transaction>> getTransactions({String accountId = ''}) async {
    if ((selectedTransactionDateFrom == null &&
            selectedTransactionDateTo != null) ||
        (selectedTransactionDateFrom != null &&
            selectedTransactionDateTo == null)) {
      return transactionList;
    }

    final result = await TransactionService.getTransactions(
      accountId: accountId,
      from: selectedTransactionDateFrom,
      to: selectedTransactionDateTo,
      type: selectedTransactionType,
    );
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
