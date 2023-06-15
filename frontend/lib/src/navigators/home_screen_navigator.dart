import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

import '../features/dashboard/dashboard.dart';

class HomeScreenNavigator extends StatelessWidget {
  const HomeScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeAppNav,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/dashboard':
            page = Dashboard();
            break;
          default:
            page = Dashboard();
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
