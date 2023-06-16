import 'package:flutter/material.dart';
import 'package:frontend/src/components/templates/header_image.dart';

/*
  Reusable "Top" component for auth related actions
  such as login, forgot password, create password
*/
class AuthHeader extends StatelessWidget {
  const AuthHeader({Key? key, required this.child, required this.title})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeaderImage(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 225),
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Savings App',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              SizedBox(
                width: 230,
                height: 80,
                child: Text(
                  'Monitor your savings, your balance, and transaction history',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 25),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              child
            ],
          ),
        ),
      ],
    );
  }
}
