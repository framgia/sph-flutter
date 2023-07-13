// ignore_for_file: constant_identifier_names

List<String> accountTypes = AccountType.values.map((e) => e.jsonValue).toList();

enum AccountType {
  // Assign fixed value as the json representation.
  SAVINGS('Savings'),
  SALARY('Salary');

  // Reference to the current enum value.
  // Ex. 'Savings'
  final String jsonValue;
  const AccountType(this.jsonValue);

  // Return the enum value from jsonValue.
  // Ex. AccountType.fromValue('Savings') will return AccountType.SAVINGS,
  static AccountType fromValue(String jsonValue) =>
      AccountType.values.singleWhere((i) => jsonValue == i.jsonValue);
}
