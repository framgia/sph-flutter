class BreakdownFilter {
  String days;
  int value;

  BreakdownFilter({
    required this.days,
    required this.value,
  });
}

List<BreakdownFilter> breakdownFilters = [
  BreakdownFilter(days: 'Overall', value: 0),
  BreakdownFilter(days: 'Today', value: 1),
  BreakdownFilter(days: 'Last 7 days', value: 7),
  BreakdownFilter(days: 'Last 30 days', value: 30),
];
