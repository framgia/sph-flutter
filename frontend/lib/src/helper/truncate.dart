import 'package:flutter/material.dart';

/*
  Reusable "truncate"
  
  The availableWidth parameter in the truncateString function is used to specify the
  available screen width.

  example: truncate(String, 20 ), // Specify the available screen width you want
*/

String truncate(String value, double availableWidth) {
  final textPainter = TextPainter(
    text: TextSpan(text: value),
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: availableWidth);

  if (textPainter.didExceedMaxLines) {
    final truncatedValue = value.substring(
      0,
      textPainter.getPositionForOffset(Offset(availableWidth, 0)).offset,
    );
    return '$truncatedValue...';
  }

  return value;
}
