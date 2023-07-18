// ignore_for_file: prefer_interpolation_to_compose_strings

/*
  Reusable "truncate"
  The maxLength parameter in the truncateString function is used to specify the
  maximum length to which a string should be truncated.

  example: truncate(String, 20 ), // Specify the maximum length you want
*/

String truncate(String value, int maxLength) {
  if (value.length <= maxLength) {
    return value;
  } else {
    return value.substring(0, maxLength) + '...';
  }
}
