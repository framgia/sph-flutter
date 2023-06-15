import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/src/components/templates/header_image.dart';
import 'package:frontend/src/features/dashboard/dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          },
        ),
        /* NOTE: All screens will now inherit the header image since it is used in all of them */
        body: HeaderImage(
          child: Dashboard(),
        ),
      ),
    );
  }
}
