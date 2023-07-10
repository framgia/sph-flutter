import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/features/transaction_history/transaction_history.dart';
import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/features/dashboard/dashboard.dart';
import 'package:frontend/src/features/account_details/account_details_page.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';

GlobalKey<NavigatorState> dashboardAppNav = GlobalKey();

class DashboardScreenNavigator extends StatelessWidget {
  const DashboardScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController homeScreenController = Get.find();

    return Navigator(
      key: dashboardAppNav,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/dashboard':
            page = Dashboard();
            break;
          case '/accountDetails':
            page = const AccountDetailsPage();
            homeScreenController.floatingActionButtonVisible = false;
            break;
          case '/transactionHistory':
            page = const TransactionHistory();
            homeScreenController.floatingActionButtonVisible = false;
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
