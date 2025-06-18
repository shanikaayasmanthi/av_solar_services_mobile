import 'dart:convert';
import 'package:av_solar_services/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;
  final result = RxnString();
  final lattitude = RxnDouble(); // Use RxnDouble for nullable double
  final longitude = RxnDouble(); // Use RxnDouble for nullable double
  final box = GetStorage();

  // Fetch location data for a given project ID
  Future<void> getLocation({required int projectId}) async {
  try {
    isLoading.value = true;
    result.value = null;
    lattitude.value = null;
    longitude.value = null;

    final response = await API().getRequest(
      route: '/project-location/$projectId',
      token: box.read('token'),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body)['data'];
      debugPrint('Decoded response: $decoded');
      
      // Check if the decoded response is a Map and contains location keys
      if (decoded is Map<String, dynamic>) {
        // Handle case where location data might be null in the response
        if (decoded['lattitude'] == null || decoded['longitude'] == null) {
          result.value = 'Location data not available for this project';
          return;
        }

        // Try to parse the values
        final lattitudeValue = double.tryParse(decoded['lattitude'].toString());
        final longitudeValue = double.tryParse(decoded['longitude'].toString());

        if (lattitudeValue != null && longitudeValue != null) {
          lattitude.value = lattitudeValue;
          longitude.value = longitudeValue;
          //result.value = 'Location data loaded successfully';
        } else {
          result.value = 'Invalid location data format';
        }
      } else {
        result.value = 'Unexpected response format';
      }
    } else if (response.statusCode == 404) {
      result.value = 'Project location not found';
    } else {
      result.value = 'Error: ${response.statusCode}';
    }
  } catch (e) {
    result.value = 'Error: ${e.toString()}';
    // You might want to log the error for debugging
    debugPrint('Error fetching location: $e');
  } finally {
    isLoading.value = false;
  }
}
  // Method to show a snackbar (can be called from UI)
  void showSnackBar(String message) {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}