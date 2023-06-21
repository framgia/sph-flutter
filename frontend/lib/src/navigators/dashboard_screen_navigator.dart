import 'package:flutter/material.dart';

import 'package:frontend/src/features/transaction_history/transaction_history.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
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
          case '/transactionHistory':
            page = const TransactionHistory();
            break;
          default:
            page = Dashboard();
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
