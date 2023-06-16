import 'package:flutter/material.dart';

import 'package:frontend/src/features/dashboard/dashboard.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';

GlobalKey<NavigatorState> dashboardAppNav = GlobalKey();

class DashboardScreenNavigator extends StatelessWidget {
  const DashboardScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: dashboardAppNav,
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
