import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import 'package:frontend/src/features/dashboard/components/add_account_dialog.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/controllers/user_profile_controller.dart';

/*
  Home screen that houses the following:
  - Navigation Bar
  - Floating Action Button
*/
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenController controller = Get.put(HomeScreenController());
    UserProfileController userProfileController =
        Get.put(UserProfileController());

    return FutureBuilder(
      future: controller.getUserIsAdmin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold();
        }

        final navigatorKeys = controller.navigatorKeys;
        final pages = controller.pages;
        final items = controller.navItems;

        Future<bool> onWillPop() {
          if (navigatorKeys[controller.currentPage].currentState!.canPop()) {
            navigatorKeys[controller.currentPage].currentState?.pop(
                  navigatorKeys[controller.currentPage].currentContext,
                );
          } else {
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          }

          return Future(() => false);
        }

        return WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
            child: Obx(
              () => Scaffold(
                floatingActionButton: Visibility(
                  visible: (controller.isAdmin &&
                          controller.currentPage == 1) ||
                      (!controller.isAdmin && controller.currentPage == 0) &&
                          controller.currentDashboardSettingsName ==
                              '/dashboard',
                  child: FloatingActionButton(
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.dialog(
                        barrierDismissible: false,
                        const AddAccountDialog(),
                      );
                    },
                  ),
                ),
                bottomNavigationBar: CurvedNavigationBar(
                  backgroundColor: const Color(0xFFDAEAEE),
                  color: const Color(0xFF5D8A99),
                  items: items,
                  onTap: (index) {
                    controller.setCurrentPage = index;

                    if (index == controller.currentPage) {
                      navigatorKeys[controller.currentPage]
                          .currentState
                          ?.popUntil((route) {
                        return route.isFirst;
                      });
                    }

                    if ((controller.isAdmin && index == 1) ||
                        (!controller.isAdmin && index == 0)) {
                      controller.setCurrentDashboardSettingsName = '/dashboard';
                    } else if ((controller.isAdmin && index == 2) ||
                        (!controller.isAdmin && index == 1)) {
                      userProfileController.getUser();
                    }
                  },
                ),
                body: IndexedStack(
                  index: controller.currentPage,
                  children: pages,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
