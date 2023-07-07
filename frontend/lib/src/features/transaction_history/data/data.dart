import 'package:frontend/src/models/transaction.dart';

// This is only a temporary data and will delete this file along with the folder
// once we have API for getting the transaction history data
List<Transaction> transactionData = [
  Transaction(
    name: 'JOASH C. CANETE',
    date: 'June 9, 2023',
    amount: '10,000',
    description: 'Received money from',
    transactionType: TransactionTypes.DEPT,
    category: Category.SAVINGS,
  ),
  Transaction(
    name: 'EGIE GARCIANO',
    date: 'June 10, 2023',
    amount: '5,000',
    description: 'Transferred money to',
    transactionType: TransactionTypes.TRANSFER,
    category: Category.SENDER,
  ),
  Transaction(
    name: 'ROBERTO DEL ROSARIO',
    date: 'June 11, 2023',
    amount: '8,000',
    description: 'Received money from',
    transactionType: TransactionTypes.TRANSFER,
    category: Category.RECIPIENT,
  ),
  Transaction(
    name: 'JOHN STEPHEN DEGILLO',
    date: 'June 12, 2023',
    amount: '900',
    description: 'Transferred money to',
    transactionType: TransactionTypes.TRANSFER,
    category: Category.SENDER,
  ),
  Transaction(
    name: 'DERICK BULAWAN',
    date: 'June 13, 2023',
    amount: '100,000',
    description: 'Received money from',
    transactionType: TransactionTypes.TRANSFER,
    category: Category.RECIPIENT,
  ),
  Transaction(
    name: 'IAN MICHAEL URRIZA',
    date: 'June 14, 2023',
    amount: '100',
    description: 'Transferred money to',
    transactionType: TransactionTypes.TRANSFER,
    category: Category.SENDER,
  ),
];
