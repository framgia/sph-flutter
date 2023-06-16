import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/main.dart';
import 'package:frontend/src/components/templates/header_image.dart';
import 'package:frontend/src/controllers/home_screen_controller.dart';
import 'package:frontend/src/features/dashboard/dashboard.dart';
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
      Dashboard(),
      const MyHomePage(title: 'temporary'),
    ];

    return Scaffold(
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
        },
      ),
      /* TODO: All screens now inherit the HeaderImage template */
      body: Obx(
        () => HeaderImage(
          child: pages[homeScreenController.currentPage],
        ),
      ),
    );
  }
}
