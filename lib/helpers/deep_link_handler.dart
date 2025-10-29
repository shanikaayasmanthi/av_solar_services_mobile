import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeepLinkHandler {
  static void handleInitialLink() {
    // This will be called when app is opened from a deep link
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleDeepLink(Get.parameters);
    });
  }

  static void handleLink(Uri? uri) {
    if (uri != null) {
      final params = uri.queryParameters;
      _handleDeepLink(params);
    }
  }

  static void _handleDeepLink(Map<String, String?> params) {
    final token = params['token'];
    final email = params['email'];
    
    if (token != null && email != null) {
      // Navigate to reset password page
      Get.toNamed('/reset-password', parameters: {
        'token': token,
        'email': email,
      });
    }
  }
}