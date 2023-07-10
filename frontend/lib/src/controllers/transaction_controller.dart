import 'package:get/get.dart';

import 'package:frontend/src/models/transaction.dart';
import 'package:frontend/src/services/transaction_service.dart';

List<String> transactionTypes = ['Credit', 'Dept', 'Transfer'];

class TransactionController extends GetxController {
  final RxString _selectedTransactionType = transactionTypes[0].obs;
  final Rx<DateTime> _selectedTransactionDate = DateTime.now().obs;
  final RxBool _transactionSubmitEnabled = false.obs;
  RxList<Transaction> transactionList = <Transaction>[].obs;

  String get selectedTransactionType => _selectedTransactionType.value;

  DateTime get selectedTransactionDate => _selectedTransactionDate.value;

  bool get transactionSubmitEnabled => _transactionSubmitEnabled.value;

  Future<List<Transaction>> getTransactions({String accountId = ''}) async {
    final result =
        await TransactionService.getTransactions(accountId: accountId);
    transactionList.assignAll(result);
    return result;
  }

  set setSelectedTransactionType(String newValue) =>
      _selectedTransactionType.value = newValue;

  set setSelectedTransactionDate(DateTime newValue) =>
      _selectedTransactionDate.value = newValue;

  set setTransactionSubmitEnabled(bool newValue) =>
      _transactionSubmitEnabled.value = newValue;

  Future<dynamic> postTransaction(
    Transaction transaction,
    String accountId,
  ) async {
    return await TransactionService.postTransaction(
      transaction,
      accountId,
    );
  }
}
