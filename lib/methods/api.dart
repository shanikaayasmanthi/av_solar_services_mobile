// In av_solar_services/methods/api.dart
import 'dart:convert';
import 'package:av_solar_services/constants/base_url.dart';
import 'package:http/http.dart' as http;

class API {
  postRequest({
    required String route,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    String url = baseUrl + route;
    return await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: _header(token),
    );
  }

  // location getRequest method
  Future<http.Response> getRequest({
    required String route,
    String? token,
  }) async {
    String url = baseUrl + route;
    return await http.get(
      Uri.parse(url),
      headers: _header(token),
    );
  }

  Map<String, String> _header(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}