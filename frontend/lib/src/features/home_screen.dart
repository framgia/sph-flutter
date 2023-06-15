import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/main.dart';
import 'package:frontend/src/components/templates/header_image.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/navigators/home_screen_navigator.dart';
import 'package:frontend/src/navigators/settings_screen_navigator.dart';
import 'package:get/get.dart';

/*
  Home screen that houses the following:
  - Navigation Bar
  - Floating Action Button
*/
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeScreenController homeScreenController = Get.put(HomeScreenController());

    final pages = [
      const HomeScreenNavigator(),
      const SettingsScreenNavigator(),
    ];

    List<GlobalKey<NavigatorState>> navigatorKeys = [
      homeAppNav,
      settingsAppNav,
    ];

    Future<bool> onWillPop() {
      if (navigatorKeys[homeScreenController.currentPage]
          .currentState!
          .canPop()) {
        navigatorKeys[homeScreenController.currentPage].currentState?.pop(
              navigatorKeys[homeScreenController.currentPage].currentContext,
            );
      } else {
        SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      }

      return Future(() => false);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: const Color(0xFFDAEAEE),
            color: const Color(0xFF5D8A99),
            items: <Widget>[
              SvgPicture.asset('assets/svg/home.svg'),
              SvgPicture.asset('assets/svg/profile_settings.svg'),
            ],
            onTap: (index) {
              /* We can change the displayed screen here*/
              // TODO (stephen): temporary navigation to previous homescreen
              homeScreenController.setCurrentPage = index;

              // reset 2nd tab when going back to 1st tab
              if (index == 0) {
                settingsAppNav.currentState?.popUntil((route) {
                  return route.isFirst;
                });
              }
            },
          ),
          /* TODO: All screens now inherit the HeaderImage template */
          body: Obx(
            () => HeaderImage(
              child: IndexedStack(
                index: homeScreenController.currentPage,
                children: pages,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
