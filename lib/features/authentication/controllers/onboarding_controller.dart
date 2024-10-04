import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Variables
  Rx<int> currentPageIndex = 0.obs;
  final pageController = PageController();

  /// Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page.
  void dotNavigationClick(index) {
    currentPageIndex.value == index;
    pageController.jumpToPage(index);
  }

  /// Update Current Index & jump to next page
  void nextPage() {
    // If its the last index then goto Login Screen.
    // Here you can define your LocalStorage to set OnBoarding bool isFirstTime = false.
    // So, that where ever app launches, app will check if isFirstTime = true, show onBoarding else show Login or Dashboard.
    if (currentPageIndex.value == 2) {

      final userStorage = GetStorage();
      userStorage.write('isFirstTime', false);

      Get.to(() => const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      // You can also use .animateToPage() Give duration and Curve
      pageController.jumpToPage(page);
    }
  }

  /// Update Current Index & jump to the last Page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
