import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/src/helper/storage.dart';
import 'package:frontend/src/navigators/dashboard_screen_navigator.dart';
import 'package:frontend/src/navigators/profile_screen_navigator.dart';
import 'package:frontend/src/navigators/users_list_screen_navigator.dart';

class HomeScreenController extends GetxController {
  final RxInt _currentPage = 0.obs;
  final RxString _currentDashboardSettingsName = '/dashboard'.obs;
  final RxBool _isAdmin = false.obs;

  int get currentPage => _currentPage.value;
  set setCurrentPage(int newValue) => _currentPage.value = newValue;

  String get currentDashboardSettingsName =>
      _currentDashboardSettingsName.value;
  set setCurrentDashboardSettingsName(String newValue) =>
      _currentDashboardSettingsName.value = newValue;

  // navbar section
  final RxList<GlobalKey<NavigatorState>> adminNavigatorKeys = [
    settingsAppNav,
    dashboardAppNav,
    profileAppNav,
  ].obs;
  final RxList<GlobalKey<NavigatorState>> userNavigatorKeys = [
    dashboardAppNav,
    profileAppNav,
  ].obs;

  final RxList<Widget> adminNavItems = [
    SvgPicture.asset('assets/svg/list.svg'),
    SvgPicture.asset('assets/svg/home.svg'),
    SvgPicture.asset('assets/svg/profile_settings.svg'),
  ].obs;
  final RxList<Widget> userNavItems = [
    SvgPicture.asset('assets/svg/home.svg'),
    SvgPicture.asset('assets/svg/profile_settings.svg'),
  ].obs;

  final RxList<Widget> adminPages = [
    const UserListScreenNavigator(),
    const DashboardScreenNavigator(),
    const ProfileScreenNavigator(),
  ].obs;
  final RxList<Widget> userPages = [
    const DashboardScreenNavigator(),
    const ProfileScreenNavigator(),
  ].obs;

  bool get isAdmin => _isAdmin.value;
  set setIsAdmin(bool newValue) => _isAdmin.value = newValue;
  RxList<GlobalKey<NavigatorState>> get navigatorKeys =>
      _isAdmin.value ? adminNavigatorKeys : userNavigatorKeys;
  RxList<Widget> get navItems =>
      _isAdmin.value ? adminNavItems : userNavItems;
  RxList<Widget> get pages =>
      _isAdmin.value ? adminPages : userPages;
  // endsection navbar

  @override
  void onInit() async {
    super.onInit();
    await getUserIsAdmin();
  }

  Future<bool> getUserIsAdmin() async {
    const storage = FlutterSecureStorage();
    final isAdminValue = await storage.read(key: StorageKeys.isAdmin.name);
    _isAdmin.value = isAdminValue == '1';

    return _isAdmin.value;
  }
}
