import 'package:flutter/material.dart';

import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/features/indiviual_components/search_field_page.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';
import 'package:frontend/main.dart';

GlobalKey<NavigatorState> settingsAppNav = GlobalKey();

class SettingsScreenNavigator extends StatelessWidget {
  const SettingsScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: settingsAppNav,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/homepage':
            page = const MyHomePage(title: 'temporary');
            break;
          case '/searchfieldpage':
            page = const SearchFieldPage();
            break;
          default:
            page = const MyHomePage(title: 'temporary');
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
