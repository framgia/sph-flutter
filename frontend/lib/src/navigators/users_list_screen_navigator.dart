import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/features/admin_user_list/admin_user_list_page.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';
import 'package:frontend/src/features/user_profile/profile_change_password.dart';
import 'package:frontend/src/features/user_profile/profile_info.dart';
import 'package:frontend/src/controllers/admin_user_list_controller.dart';

GlobalKey<NavigatorState> settingsAppNav = GlobalKey();

class UserListScreenNavigator extends StatelessWidget {
  const UserListScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    AdminUserListController controller = Get.put(AdminUserListController());

    return Navigator(
      key: settingsAppNav,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/adminuserlistpage':
            page = const AdminUserListPage();
            break;
          case '/profileInfo':
            final args = settings.arguments as ProfileScreenArguments;
            page = ProfileInfo(
              profileUserId: args.userId,
              withBackIcon: true,
              backIconOnTap: () async {
                await controller.getUsers();
                settingsAppNav.currentState?.pop();
              },
              changePassBtnOnPressed: () {
                settingsAppNav.currentState?.pushNamed(
                  '/profileChangePassword',
                  arguments: ProfileScreenArguments(userId: args.userId),
                );
              },
            );
            break;
          case '/profileChangePassword':
            final args = settings.arguments as ProfileScreenArguments;
            page = ProfileChangePassword(
              profileUserId: args.userId,
              backIconOnTap: () {
                settingsAppNav.currentState?.pop();
              },
            );
            break;
          default:
            page = const AdminUserListPage();
            break;
        }

        return CustomPageRoute(
          builder: (context) {
            // TODO: Get the auth token form BE
            return AuthHeader(
              hasAuthToken: true,
              child: page,
            );
          },
          settings: settings,
        );
      },
    );
  }
}

class ProfileScreenArguments {
  final String userId;

  ProfileScreenArguments({
    required this.userId,
  });
}
