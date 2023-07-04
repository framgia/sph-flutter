import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:get/get.dart';

class AuthHeaderController extends GetxController {
  final RxString _name = ''.obs;

  String get name => _name.value;

  Future<String> getFullName() async {
    const storage = FlutterSecureStorage();
    final fullName = await storage.read(key: StorageKeys.fullName.name);
    _name.value = fullName!;

    return fullName;
  }
}
