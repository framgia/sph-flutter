import 'package:flutter/material.dart';

/*
  Reusable button component.

  @param text, describes the button.

  @param onPressed, optional function and this is called when user pressed the widget.

  @param padding, the padding to be added around the text.
*/
class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
    this.buttonColor = const Color(0xFF00CCFF),
    this.withShadow = true,
    this.radius = 100,
    this.size,
  });

  final String text;
  final void Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final Color buttonColor;
  final bool withShadow;
  final double radius;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: withShadow
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          backgroundColor: buttonColor,
          fixedSize: size,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
