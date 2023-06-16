import 'package:flutter/material.dart';

/*
  Reusable "Top" component for auth related actions
  such as login, forgot password, create password

  @param hasAuthToken, bool value to tell if user is authenticated or not.
*/
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    this.hasAuthToken = false,
    required this.child,
  });

  final bool hasAuthToken;
  final Widget child;

  // TODO: make also the header scrollable.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 100, 0),
              child: Image.asset(
                'assets/images/corner.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 62, 25, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Image.asset('assets/images/sph-flutter-logo.png'),
                  ),
                  Visibility(
                    visible: hasAuthToken,
                    child: Text(
                      'JOASH C. CANETE',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !hasAuthToken,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 225, bottom: 33),
                  child: Column(
                    children: [
                      Text(
                        'Savings App',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 11),
                      SizedBox(
                        width: 220,
                        child: Text(
                          'Monitor your savings, your balance, and transaction history',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(child: child),
      ],
    );
  }
}
