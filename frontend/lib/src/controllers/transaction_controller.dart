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
  final Rxn<DateTime> _selectedTransactionDateFrom = Rxn<DateTime>();
  final Rxn<DateTime> _selectedTransactionDateTo = Rxn<DateTime>();
  final RxBool _transactionSubmitEnabled = false.obs;
  RxList<Transaction> transactionList = <Transaction>[].obs;
  TransactionTypes get selectedTransactionType =>
      _selectedTransactionType.value;

  TransactionCategories get selectedTransactionCategory =>
      _selectedTransactionCategory.value;

  DateTime? get selectedTransactionDateFrom =>
      _selectedTransactionDateFrom.value;

  DateTime? get selectedTransactionDateTo => _selectedTransactionDateTo.value;

  bool get transactionSubmitEnabled => _transactionSubmitEnabled.value;

  set setSelectedTransactionType(TransactionTypes newValue) =>
      _selectedTransactionType.value = newValue;

  set setSelectedTransactionCategory(TransactionCategories newValue) =>
      _selectedTransactionCategory.value = newValue;

  set setSelectedTransactionDateFrom(DateTime? newValue) =>
      _selectedTransactionDateFrom.value = newValue;

  set setSelectedTransactionDateTo(DateTime? newValue) =>
      _selectedTransactionDateTo.value = newValue;

  set setTransactionSubmitEnabled(bool newValue) =>
      _transactionSubmitEnabled.value = newValue;

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
