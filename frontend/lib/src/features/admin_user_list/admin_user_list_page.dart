import 'package:flutter/material.dart';
import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/search_field.dart';
import 'package:frontend/src/controllers/admin_user_list_controller.dart';
import 'package:frontend/src/features/admin_user_list/components/user_list_tile.dart';
import 'package:frontend/src/models/user.dart';
import 'package:get/get.dart';

/*
  The page where admins can see all the users.
*/

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    AdminUserListController controller = Get.put(AdminUserListController());

    return GetX<AdminUserListController>(
      builder: (_) => RefreshIndicator(
        onRefresh: () {
          return controller.getUsers();
        },
        child: Column(
          children: [
            const Breadcrumb(
              text: "List of Users",
              withBackIcon: false,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const SearchField(
                      name: "name",
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          User user = controller.users.elementAt(index);

                          return UserListTile(
                            name: '${user.firstName} ${user.lastName}',
                            isAdmin: user.isAdmin == 1,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 1,
                            color: Color.fromRGBO(109, 120, 129, 1),
                          );
                        },
                        itemCount: controller.users.length,
                        // prevent negative itemcount
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
