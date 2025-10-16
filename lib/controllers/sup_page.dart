import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SupervisorPageController extends GetxController{

  var currentPage = 0.obs;
  var selectedService = 0.obs;
  var selectedServiceData = <String, dynamic>{}.obs; // Add this line
  var isEditingService = false.obs; // Add this line
  var showFormFullScreen = false.obs;

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
  void openEditServiceForm(int serviceId) {
    selectedService.value = serviceId;
    currentPage.value = 4; // New page for editing
    isEditingService.value = true;
    showFormFullScreen.value = true; // Show form in full screen
  }


  void closeServiceDetails() {
    debugPrint('done');
    currentPage.value = 0;
    selectedService.value =0;
  }
}