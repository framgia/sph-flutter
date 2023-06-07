import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 100, 25),
          child: Image.asset(
            'images/corner.png',
          ),
        ),
        Container(
          height: 252,
          alignment: Alignment.bottomCenter,
          child: const Text(
            'Savings App',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
