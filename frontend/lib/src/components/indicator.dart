import 'package:flutter/material.dart';

/*
  A Indicator widget displays graph labels

  @param color, defines the color of the indicator

  @param text, the indicator text

  @param isSquare, defines if the label icon is circle or square

  @param size, label icon size

  @param textColor, color of the text indicator
*/

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
        )
      ],
    );
  }
}
