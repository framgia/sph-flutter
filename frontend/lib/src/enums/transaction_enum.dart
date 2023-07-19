// ignore_for_file: constant_identifier_names

enum TransactionType {
  ALL('All transactions'),
  CREDIT('Credit'),
  DEPT('Deposit'),
  TRANSFER('Transfer');

  final String value;
  const TransactionType(this.value);

  static TransactionType fromValue(String value) =>
      TransactionType.values.singleWhere((i) => value == i.value);

  // Return TransactionType if string = name
  // Ex. TransactionType.fromJSON('CREDIT') = TransactionType.CREDIT
  static TransactionType fromJson(String jsonValue) =>
      TransactionType.values.singleWhere((i) => jsonValue == i.name);
}

enum TransactionCategory {
  FOOD('Food/Drinks'),
  TRANSPORTATION('Transportation'),
  BILLS('Housing/Billings'),
  SAVINGS('Savings'),
  SALARY('Salary'),
  SENDER('Sender'),
  RECIPIENT('Recipient'),
  MISC('Miscellaneous');

  final String value;
  const TransactionCategory(this.value);

  static List<String> creditCategories = [
    TransactionCategory.FOOD.value,
    TransactionCategory.TRANSPORTATION.value,
    TransactionCategory.BILLS.value,
    TransactionCategory.SAVINGS.value,
    TransactionCategory.MISC.value,
  ];

  // Return TransactionCategory if string = value
  // Ex. TransactionCategory.fromValue('Savings') = TransactionCategory.SAVINGS
  static TransactionCategory fromValue(String value) =>
      TransactionCategory.values.singleWhere((i) => value == i.value);

  // Return TransactionCategory if string = name
  // Ex. TransactionCategory.fromJSON('BILLS') = TransactionCategory.BILLS
  static TransactionCategory fromJson(String jsonValue) =>
      TransactionCategory.values.singleWhere((i) => jsonValue == i.name);
}
