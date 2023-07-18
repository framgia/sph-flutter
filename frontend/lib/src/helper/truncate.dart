import 'package:flutter/material.dart';

/*
  Reusable "truncate"

  The value parameter represents the string value that needs to be truncated if necessary.

  The maxWidth parameter in the truncate function is used to specify the
  available screen width.

  Example: truncate(value: "xyz", maxWidth: 20), // Specify the available screen width you want
*/

String truncate({required String value, required double maxWidth}) {
  final textPainter = TextPainter(
    text: TextSpan(text: value),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: maxWidth);

  if (textPainter.didExceedMaxLines) {
    final truncatedValue = value.substring(
      0,
      textPainter.getPositionForOffset(Offset(maxWidth, 0)).offset,
    );
    return '$truncatedValue...';
  }

  return value;
}
