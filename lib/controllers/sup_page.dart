import 'package:get/get.dart';

class SupervisorPageController extends GetxController{

  var currentPage = 0.obs;
  var selectedService = ''.obs;

  void goToHome() {
    currentPage.value = 0;
  }

  void goToProfile() {
    currentPage.value = 1;
  }

  void openServiceDetails(String serviceId) {
    selectedService.value = serviceId;
    currentPage.value = 2;
  }

  void closeServiceDetails() {
    currentPage.value = 0;
    selectedService.value ='';
  }
}