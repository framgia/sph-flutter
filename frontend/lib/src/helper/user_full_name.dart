import 'package:frontend/src/models/user.dart';

// constructs a full Name from a user object
// ex. Foo X. Bar
// or  Bar Foo
String userFullName(User user) {
  final middleName = user.middleName != null ? 
    '${user.middleName}. ' : '';
  
  return '${user.firstName} $middleName${user.lastName}';
}
