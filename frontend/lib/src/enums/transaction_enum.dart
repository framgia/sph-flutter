// ignore_for_file: constant_identifier_names

enum TransactionType {
  ALL('All transactions'),
  CREDIT('Credit'),
  DEPT('Deposit'),
  TRANSFER('Transfer');

  final String value;
  const TransactionType(this.value);

  // Parse the custom value and return the matching enum type.
  // Ex. TransactionType.fromValue('Credit') will return TransactionType.CREDIT,
  static TransactionType fromValue(String value) =>
      TransactionType.values.singleWhere((i) => value == i.value);

  // Parse the json data from BE and return the matching enum type.
  // Ex. TransactionType.fromJson('CREDIT') will return TransactionType.CREDIT,
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

  // Parse the custom value and return the matching enum type.
  // Ex. TransactionCategory.fromValue('Savings') will return TransactionCategory.SAVINGS,
  static TransactionCategory fromValue(String value) =>
      TransactionCategory.values.singleWhere((i) => value == i.value);

  // Parse the json data from BE and return the matching enum type.
  // Ex. TransactionCategory.fromJson('SAVINGS') will return TransactionCategory.SAVINGS,
  static TransactionCategory fromJson(String jsonValue) =>
      TransactionCategory.values.singleWhere((i) => jsonValue == i.name);
}
