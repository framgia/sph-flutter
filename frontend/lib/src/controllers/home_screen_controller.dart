import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final RxInt _currentPage = 0.obs;

  int get currentPage => _currentPage.value;

  set setCurrentPage(int newValue) => _currentPage.value = newValue;
}
