import 'package:get/get.dart';

import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/services/user_service.dart';

class AdminUserListController extends GetxController {
  RxList<User> users = <User>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getUsers();
  }

  Future<List<User>> getUsers() async {
    final result = await UserService.getUsers();
    users.assignAll(result);
    return result;
  }
}
