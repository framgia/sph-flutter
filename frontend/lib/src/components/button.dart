import 'package:flutter/material.dart';

/*
  Reusable button component.

  @param text, describes the button.

  @param enabled, boolean to enable or disable the button's onPressed callback

  @param onPressed, optional function and this is called when user pressed the widget.

  @param padding, the padding to be added around the text.

  @param buttonColor, can change button color

  @param withShadow, optional if button needs box shadow or not

  @param radius, to optionally change the radius of the button

  @param size, to optionally set a fixed size of the button
*/
class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.enabled = true,
    this.onPressed,
    this.padding,
    this.buttonColor = const Color(0xFF00CCFF),
    this.withShadow = true,
    this.radius = 100,
    this.size,
  });

  final String text;
  final bool enabled;
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
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: padding,
          backgroundColor: enabled ? buttonColor : Colors.grey,
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
