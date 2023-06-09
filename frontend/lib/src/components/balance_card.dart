import 'package:flutter/material.dart';

/*
  A Balance Card widget where you can display account balance with static design of the card.

  @param content, a widget type of content that will be displayed inside the card.
*/

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox(width: double.infinity, child: content),
      ),
    );
  }
}
