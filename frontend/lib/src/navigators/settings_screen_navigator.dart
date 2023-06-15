import 'package:flutter/material.dart';
import 'package:frontend/src/features/indiviual_components/search_field_page.dart';
import 'package:frontend/src/features/password_reset/password_reset_page.dart';

import '../../main.dart';

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
          case '/passwordresetpage':
            page = const PasswordResetPage();
            break;
          default:
            page = const MyHomePage(title: 'temporary');
            break;
        }

        return MaterialPageRoute(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
    );
  }
}
