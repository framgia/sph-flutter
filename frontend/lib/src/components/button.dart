import 'package:flutter/material.dart';

/*
  Reusable button component.

  @param text, describes the button.

  @param onPressed, optional function and this is called when user pressed the widget.
*/
class Button extends StatelessWidget {
  const Button({super.key, required this.text, this.onPressed});

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 55,
            vertical: 16,
          ),
          backgroundColor: const Color(0xFF00CCFF),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.apply(bodyColor: Colors.white).labelMedium,
        ),
      ),
    );
  }
}
