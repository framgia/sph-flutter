// ignore_for_file: constant_identifier_names

enum TransactionTypes { CREDIT, DEPT, TRANSFER }

enum TransactionCategories {
  FOOD,
  TRANSPORTATION,
  BILLS,
  SAVINGS,
  SALARY,
  SENDER,
  RECIPIENT,
  MISC,
}

List<String> creditCategories = TransactionCategories.values
    .where(
  (value) =>
      value == TransactionCategories.FOOD ||
      value == TransactionCategories.TRANSPORTATION ||
      value == TransactionCategories.BILLS ||
      value == TransactionCategories.SAVINGS ||
      value == TransactionCategories.MISC,
)
    .map((value) {
  switch (value) {
    case TransactionCategories.FOOD:
      return 'Food/Drinks';
    case TransactionCategories.TRANSPORTATION:
      return 'Transportation';
    case TransactionCategories.BILLS:
      return 'Housing/Billings';
    case TransactionCategories.SAVINGS:
      return 'Savings';
    case TransactionCategories.MISC:
      return 'Miscellaneous';
    default:
      return '';
  }
}).toList();

extension TransactionCategoriesExtension on TransactionCategories {
  String get value {
    switch (this) {
      case TransactionCategories.FOOD:
        return 'Food/Drinks';
      case TransactionCategories.TRANSPORTATION:
        return 'Transportation';
      case TransactionCategories.BILLS:
        return 'Housing/Billings';
      case TransactionCategories.SAVINGS:
        return 'Savings';
      case TransactionCategories.MISC:
        return 'Miscellaneous';
      default:
        return '';
    }
  }
}

TransactionCategories transactionCategoriesFromString(
  String creditTransaction,
) {
  switch (creditTransaction) {
    case 'Food/Drinks':
      return TransactionCategories.FOOD;
    case 'Transportation':
      return TransactionCategories.TRANSPORTATION;
    case 'Housing/Billings':
      return TransactionCategories.BILLS;
    case 'Savings':
      return TransactionCategories.SAVINGS;
    case 'Miscellaneous':
      return TransactionCategories.MISC;
    default:
      return TransactionCategories.MISC;
  }
}
