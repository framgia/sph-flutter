import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend/src/models/transaction.dart';
import 'package:intl/intl.dart';

/*
  Component only for transaction history page.

  @param transaction, contains transaction details.
*/
class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});

  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    TextTheme customTextTheme = Theme.of(context).textTheme.copyWith(
          titleMedium: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          titleSmall: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6D7881),
          ),
        );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFF6D7881)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.generateDescription(),
                  style: customTextTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.participantName ?? '',
                  style: customTextTheme.titleMedium,
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('MMMM d, y').format(transaction.transactionDate),
                style: customTextTheme.titleSmall,
              ),
              Row(
                children: [
                  if (transaction.amount > 0)
                    const FaIcon(
                      FontAwesomeIcons.plus,
                      size: 13,
                      color: Color(0xFF00FF38),
                    )
                  else
                    const FaIcon(
                      FontAwesomeIcons.minus,
                      size: 13,
                      color: Color(0xFFFF0000),
                    ),
                  const SizedBox(width: 6),
                  const FaIcon(
                    FontAwesomeIcons.pesoSign,
                    size: 13,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    transaction.amount.abs().toStringAsFixed(2),
                    style: customTextTheme.titleMedium,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
