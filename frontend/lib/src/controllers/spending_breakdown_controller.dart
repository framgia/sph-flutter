import 'package:frontend/src/const/spending_breakdown_test_data.dart';
import 'package:get/get.dart';

import 'package:frontend/src/const/spending_breakdown_filter.dart';

class SpendingBreakdownController extends GetxController {
  final Rx<BreakdownFilter> _selectedBreakdownFilter = breakdownFilters[0].obs;
  final RxDouble _totalSpent = 0.00.obs;

  BreakdownFilter get selectedBreakdownFilter => _selectedBreakdownFilter.value;

  double get totalSpent => _totalSpent.value;

  set setSelectedBreakdownFilter(BreakdownFilter newValue) =>
      _selectedBreakdownFilter.value = newValue;

  set setTotalSpent(double newValue) => _totalSpent.value = newValue;

  // TODO: replace during integration of Spending Breakdown
  getSpendingBreakdown() {
    var totalExpenses = 0.0;

    for (var breakdown in spendingBreakdownData) {
      totalExpenses += breakdown.totalTransactionAmount;
    }

    _totalSpent.value = totalExpenses;
  }
}
