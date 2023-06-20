import 'package:flutter/material.dart';

/*
  Refactored button widget for the account card

  Parameter onClick function and this is called when user pressed the widget.
*/
class AccountCardButton extends StatelessWidget {
  const AccountCardButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.onClick,
  }) : super(key: key);

  final String text;
  final Color backgroundColor;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        color: backgroundColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        height: 25.0,
        padding: const EdgeInsets.all(0.0),
        onPressed: onClick,
        child: FittedBox(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
