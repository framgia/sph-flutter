import 'package:get/get.dart';

import 'package:frontend/src/const/spending_breakdown_filter.dart';
import 'package:frontend/src/models/spending_breakdown.dart';
import 'package:frontend/src/services/account_service.dart';

class SpendingBreakdownController extends GetxController {
  final Rx<BreakdownFilter> _selectedBreakdownFilter = breakdownFilters[0].obs;
  final RxDouble _totalSpent = 0.00.obs;
  final RxList<SpendingBreakdown> _spendingList = <SpendingBreakdown>[].obs;

  BreakdownFilter get selectedBreakdownFilter => _selectedBreakdownFilter.value;
  List<SpendingBreakdown> get spendingList => _spendingList;

  double get totalSpent => _totalSpent.value;

  set setSelectedBreakdownFilter(BreakdownFilter newValue) =>
      _selectedBreakdownFilter.value = newValue;

  set setTotalSpent(double newValue) => _totalSpent.value = newValue;

  Future<List<SpendingBreakdown>> getSpendingBreakdown({
    String accountId = '',
    int days = 0,
  }) async {
    accountId = accountId;
    var totalExpenses = 0.0;
    _spendingList.value = await AccountService.getBreakdown(
      accountId: accountId,
      days: days,
    );

    for (var breakdown in spendingList) {
      totalExpenses += breakdown.totalTransactionAmount;
    }

    _totalSpent.value = totalExpenses;

    return spendingList;
  }

  void resetFilters() {
    _selectedBreakdownFilter.value = breakdownFilters[0];
  }
}
