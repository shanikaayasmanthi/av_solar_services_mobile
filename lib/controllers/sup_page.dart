import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SupervisorPageController extends GetxController{

  var currentPage = 0.obs;
  var selectedService = 0.obs;

  void goToHome() {
    currentPage.value = 0;
  }

  void goToSummarize(){
    currentPage.value = 1;
  }

  void goToProfile() {
    currentPage.value = 2;
  }

  void openServiceDetails(int serviceId) {
    selectedService.value = serviceId;
    currentPage.value = 3;
  }

  void closeServiceDetails() {
    debugPrint('done');
    currentPage.value = 0;
    selectedService.value =0;
  }
}