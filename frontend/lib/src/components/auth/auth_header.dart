import 'package:flutter/material.dart';

/*
  Reusable "Top" component for auth related actions
  such as login, forgot password, create password
*/
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
          child: Text(
            'SPH FLUTTER',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
