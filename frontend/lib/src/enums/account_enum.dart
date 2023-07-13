// ignore_for_file: constant_identifier_names

enum AccountType {
  // Assign fixed value as the json representation.
  SAVINGS('Savings'),
  SALARY('Salary');

  // Reference to the current enum value.
  // Ex. 'Savings'
  final String value;
  const AccountType(this.value);

  // Return the enum value of that type.
  // Ex. AccountType.fromValue('Savings') will return AccountType.SAVINGS,
  static AccountType fromValue(String jsonValue) =>
      AccountType.values.singleWhere((i) => jsonValue == i.value);
}

List<String> accountTypes = AccountType.values.map((e) => e.value).toList();
