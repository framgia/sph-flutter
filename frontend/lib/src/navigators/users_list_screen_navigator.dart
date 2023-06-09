import 'package:flutter/material.dart';

import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/features/admin_user_list/admin_user_list_page.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';

GlobalKey<NavigatorState> settingsAppNav = GlobalKey();

class UserListScreenNavigator extends StatelessWidget {
  const UserListScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: settingsAppNav,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/adminuserlistpage':
            page = const AdminUserListPage();
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
