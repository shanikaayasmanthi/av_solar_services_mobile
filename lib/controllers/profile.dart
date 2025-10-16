import 'dart:convert';
import 'package:av_solar_services/methods/api.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var isLoading = true.obs;
  var profileData = {}.obs;

  // 🔹 Load profile data
  Future<void> loadProfile({required int userId}) async {
    try {
      isLoading.value = true;

      final response = await API().getRequest(
        route: "/supervisor-profile/$userId",
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        profileData.value = body['data'];
      }
    } catch (e) {
      // handle errors gracefully
      profileData.value = {};
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
  required int userId,
  required String name,
  required String email,
  required String phone,
  required String address,
}) async {
  try {
    final response = await API().postRequest(
      route: "/update-supervisor-profile/$userId",
     data: {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      profileData.value = body['data']; // 🔹 update local state
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

}
