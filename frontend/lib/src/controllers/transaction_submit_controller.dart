import 'package:get/get.dart';

class TransactionSubmitController extends GetxController {
  final RxBool _transactionSubmitEnabled = false.obs;

  bool get transactionSubmitEnabled => _transactionSubmitEnabled.value;

  set setTransactionSubmitEnabled(bool newValue) =>
      _transactionSubmitEnabled.value = newValue;
}
