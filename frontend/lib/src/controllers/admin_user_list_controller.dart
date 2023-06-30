import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/services/user_service.dart';
import 'package:get/get.dart';

class AdminUserListController extends GetxController {
  RxList<User> users = <User>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getUsers();
  }

  Future<void> getUsers() async {
    users.assignAll(await UserService.getUsers());
  }

  Future<String> getUserId() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: StorageKeys.userId.name) ?? '';
  }
}
