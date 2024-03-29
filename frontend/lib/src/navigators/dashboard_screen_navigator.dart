import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:frontend/src/components/auth/auth_header.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/controllers/transaction_controller.dart';
import 'package:frontend/src/features/account_details/account_details_page.dart';
import 'package:frontend/src/features/dashboard/dashboard.dart';
import 'package:frontend/src/features/transaction_history/transaction_history.dart';
import 'package:frontend/src/navigators/custom_page_route.dart';
import 'package:frontend/src/features/spending_breakdown/spending_breakdown_page.dart';

GlobalKey<NavigatorState> dashboardAppNav = GlobalKey();

class DashboardScreenNavigator extends StatelessWidget {
  const DashboardScreenNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController homeScreenController = Get.find();
    final TransactionController transactionController =
        Get.put(TransactionController());

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
            transactionController.setSelectedTransactionDateFrom = null;
            transactionController.setSelectedTransactionDateTo = null;
            homeScreenController.floatingActionButtonVisible = false;
            break;
          case '/spendingBreakdown':
            page = const SpendingBreakdownPage();
            homeScreenController.floatingActionButtonVisible = false;
            break;
          default:
            page = Dashboard();
            break;
        }

        return CustomPageRoute(
          builder: (context) {
            return AuthHeader(child: page);
          },
          settings: settings,
        );
      },
    );
  }
}
