import 'package:get/get.dart';

import 'package:frontend/src/const/spending_breakdown_filter.dart';

class SpendingBreakdownController extends GetxController {
  final Rx<BreakdownFilter> _selectedBreakdownFilter = breakdownFilters[0].obs;

  BreakdownFilter get selectedBreakdownFilter => _selectedBreakdownFilter.value;

  set setSelectedBreakdownFilter(BreakdownFilter newValue) =>
      _selectedBreakdownFilter.value = newValue;
}
