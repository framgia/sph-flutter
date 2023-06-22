import 'package:frontend/src/models/user.dart';
import 'package:frontend/src/services/user_service.dart';
import 'package:get/get.dart';

class AdminUserListController extends GetxController {
  RxList<User> users = <User>[].obs;

  @override
  void onInit() async {
    await getUsers();
    super.onInit();
  }

  Future<void> getUsers() async {
    users.assignAll(await UserService.getUsers());
  }
}
