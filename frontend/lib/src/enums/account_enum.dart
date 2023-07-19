// ignore_for_file: constant_identifier_names

enum AccountType {
  // Assign fixed value as the json representation.
  SAVINGS('Savings'),
  SALARY('Salary');

  // Reference to the current enum value.
  // Ex. 'Savings'
  final String value;
  const AccountType(this.value);

  // Parse the custom value and return the matching enum type.
  // Ex. AccountType.fromValue('Savings') will return AccountType.SAVINGS,
  static AccountType fromValue(String value) =>
      AccountType.values.singleWhere((i) => value == i.value);

  // Parse the json data from BE and return the matching enum type.
  // Ex. AccountType.fromJson('SAVINGS') will return AccountType.SAVINGS,
  static AccountType fromJson(String jsonValue) =>
      AccountType.values.singleWhere((i) => jsonValue == i.name);
}

List<String> accountTypes = AccountType.values.map((e) => e.value).toList();
