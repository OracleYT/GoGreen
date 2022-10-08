import 'dart:convert';

import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  AdvancedDrawerController advancedDrawerController;

  @override
  void onInit() {
    super.onInit();
    advancedDrawerController = AdvancedDrawerController();
  }

  onPageChange(index) {
    currentIndex.value = index;
  }
}
