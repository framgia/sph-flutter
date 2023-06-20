import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final RxInt _currentPage = 0.obs;

  final RxString _currentDashboardSettingsName = '/dashboard'.obs;

  int get currentPage => _currentPage.value;

  String get currentDashboardSettingsName => _currentDashboardSettingsName.value;

  set setCurrentPage(int newValue) => _currentPage.value = newValue;

  set setCurrentDashboardSettingsName(String newValue) =>
      _currentDashboardSettingsName.value = newValue;
}
