import 'package:flutter/material.dart';

import 'package:frontend/src/features/user_profile/profile_info.dart';
import 'package:frontend/src/features/user_profile/profile_change_password.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';

GlobalKey<NavigatorState> profileAppNav = GlobalKey();

class ProfileScreenNavigator extends StatelessWidget {
  const ProfileScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileAppNav,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/profileInfo':
            page = const ProfileInfo();
            break;
          case '/profileChangePassword':
            page = const ProfileChangePassword();
            break;
          default:
            page = const ProfileInfo();
            break;
        }

        return CustomPageRoute(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
    );
  }
}
