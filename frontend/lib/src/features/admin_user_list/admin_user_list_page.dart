import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'package:frontend/src/components/breadcrumb.dart';
import 'package:frontend/src/components/input/search_field.dart';
import 'package:frontend/src/controllers/admin_user_list_controller.dart';
import 'package:frontend/src/features/admin_user_list/components/user_list_tile.dart';
import 'package:frontend/src/models/user.dart';

/*
  The page where admins can see all the users.
*/

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    AdminUserListController controller = Get.put(AdminUserListController());
    final debouncer = Debouncer(delay: const Duration(milliseconds: 400));

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
                    child: SearchField(
                      name: "search",
                      onChanged: (value) {
                        debouncer(
                          () async {
                            await controller.getUsers(keyword: value ?? '');
                          },
                        );
                      },
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
                      child: controller.users.isEmpty
                          ? Center(
                              child: Text(
                                'No users found.',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                User user = controller.users.elementAt(index);

                                return UserListTile(
                                  name: '${user.firstName} ${user.lastName}',
                                  isAdmin: user.isAdmin == 1,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
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
