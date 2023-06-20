import 'package:get/get.dart';

List<String> transactionTypes = ['Credit', 'Dept', 'Transfer'];

class TransactionController extends GetxController {
  final RxString _selectedTransactionType = transactionTypes[0].obs;

  final Rx<DateTime> _selectedTransactionDate = DateTime.now().obs;

  String get selectedTransactionType => _selectedTransactionType.value;

  DateTime get selectedTransactionDate => _selectedTransactionDate.value;

  set setSelectedTransactionType(String newValue) =>
      _selectedTransactionType.value = newValue;

  set setSelectedTransactionDate(DateTime newValue) =>
      _selectedTransactionDate.value = newValue;
}
