// ignore_for_file: constant_identifier_names

enum TransactionTypes {
  ALL('All transactions'),
  CREDIT('Credit'),
  DEPT('Deposit'),
  TRANSFER('Transfer');

  final String value;
  const TransactionTypes(this.value);

  static TransactionTypes fromValue(String value) =>
      TransactionTypes.values.singleWhere((i) => value == i.value);
}

enum TransactionCategories {
  FOOD('Food/Drinks'),
  TRANSPORTATION('Transportation'),
  BILLS('Housing/Billings'),
  SAVINGS('Savings'),
  SALARY('Salary'),
  SENDER('Sender'),
  RECIPIENT('Recipient'),
  MISC('Miscellaneous');

  final String value;
  const TransactionCategories(this.value);

  static List<String> creditCategories = [
    TransactionCategories.FOOD.value,
    TransactionCategories.TRANSPORTATION.value,
    TransactionCategories.BILLS.value,
    TransactionCategories.SAVINGS.value,
    TransactionCategories.MISC.value,
  ].toList();

  static TransactionCategories fromValue(String jsonValue) =>
      TransactionCategories.values.singleWhere((i) => jsonValue == i.value);
}
