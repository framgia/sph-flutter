import 'package:get/get.dart';

class GraphController extends GetxController {
  final RxInt _focusIndex = (-1).obs;

  int get focusIndex => _focusIndex.value;
  set setFocusIndex(int newValue) => _focusIndex.value = newValue;
}
