import 'package:flutter/material.dart';

/*
  Component for a Button
  designed with shadow, border

  PARAMETER onClick: a fuction that triger the button if click
  ex: onClick: onSubmit,

  PARAMETER text: A String used to add text in the button.
  ex: text: 'Login',
*/

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onClick,
    required this.text,
  });

  final Function() onClick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size.fromWidth(245),
        backgroundColor: const Color.fromARGB(255, 0, 204, 255),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 90,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
