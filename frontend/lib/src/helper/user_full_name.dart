import 'package:frontend/src/models/user.dart';

import 'capitalize_first_letter.dart';

// constructs a full Name from a user object
// ex. Foo X. Bar
// or  Bar Foo
String userFullName(User user) {
  final middleName = capitalizeFirstLetter(
    user.middleName != null ? '${user.middleName[0]}. ' : '',
  );

  return '${capitalizeFirstLetter(user.firstName)} $middleName${capitalizeFirstLetter(user.lastName)}';
}
