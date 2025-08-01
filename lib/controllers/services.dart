import 'dart:convert';

import 'package:av_solar_services/methods/api.dart';
import 'package:av_solar_services/models/Customer.dart';
import 'package:av_solar_services/models/Service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../models/completed_service.dart';

class ServicesController extends GetxController {
  final isLoading = false.obs;
  final result = RxnString();

  final box = GetStorage();

  // Add this method to your ServicesController
  Future<List<CompletedService>> getCompletedServicesByProject({
    required int projectId,
  }) async {
    try {
      var data = {
        'project_id': projectId,
      };

      final response = await API().postRequest(
        route: '/sup/get_completed_services_by_project',
        data: data,
        token: box.read('token'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> services = decoded['data']['services'];
        return services.map((json) => CompletedService.fromJson(json)).toList();
      } else {
        result.value = 'Error fetching completed services';
        return [];
      }
    } catch (e) {
      result.value = 'Error: ${e.toString()}';
      return [];
    }
  }

  //get all services for supervisor
  Future<List<Service>> getServices({
    required int userId,
  }) async {
    try {
      if (box.read('token') != null) {
        var data = {'user_id': userId};
        final response = await API().postRequest(
            route: '/sup/services',
            data: data,
            token: box.read('token').toString());

        if (response.statusCode == 200) {
          // debugPrint(response.body);
          isLoading.value = false;
          // debugPrint(json.decode(response.body));
          final decoded = json.decode(response.body);
          // debugPrint(decoded["data"]);
          final List<dynamic> serviceList = decoded["data"]["Services"];
          return serviceList.map((e) => Service.fromJson(e)).toList();
        } else {
          result.value = 'Something went Wrong';
          return [];
        }
      } else {
        result.value = 'Something went Wrong';
        return [];
      }
    } catch (e) {
      print(('Error$e'));
      result.value = 'An Error Occurred';
      return [];
    }
  }

  //set time for a service
  Future setTime({
    required int userId,
    required int serviceId,
    required int projectId,
    required int projectNo,
    required String time,
  }) async {
    try {
      result.value = '';
      if (box.read('token') != null) {
        if (time != "00:00 AM") {
          debugPrint(time);
          var data = {
            'user_id': userId,
            'service_id': serviceId,
            'project_id': projectId,
            'project_no': projectNo,
            'time': time,
          };

          final response = await API().postRequest(
            route: "/sup/set_service_time",
            data: data,
            token: box.read('token'),
          );
          if (response.statusCode == 200) {
            final decoded = json.decode(response.body);
            result.value =
                "Successfully reserved $time for service of project No : $projectNo";
            return decoded['data']['result'];
          } else {
            result.value = "Error occurred! Try Again";
            return 0;
          }
        } else {
          result.value = "Set the time";
        }
      }
    } catch (e) {
      result.value = "Error occurred";
      return 0;
    }
  }

  //get project id from service id
  Future getProjectId({required int userId, required int serviceId}) async {
    try {
      var data = {'service_id': serviceId, 'user_id': userId};

      final response = await API().postRequest(
        route: '/sup/get_service_ProjectNo',
        data: data,
        token: box.read('token'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else if (response.statusCode == 401) {
        result.value = 'Unauthorized';
        return [];
      } else {
        result.value = 'Error occurred';
        return [];
      }
    } catch (e) {
      result.value = e.toString();
      return [];
    }
  }

  //get customer details of the project
  Future getCustomer({
    required int projectId,
  }) async {
    try {
      var data = {'project_id': projectId};
      final response = await API().postRequest(
          route: '/sup/get_customer', data: data, token: box.read('token'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // debugPrint(decoded.toString());
        final nestedData = decoded['data'];

        if (nestedData != null && nestedData['customer'] != null) {
          return Customer.fromNestedJson(nestedData);
        } else {
          // debugPrint('Customer or data is null');
          result.value = 'Customer or data is null';
          return null;
        }
      } else {
        // debugPrint('Failed with status code: ${response.statusCode}');
        result.value = 'Failed with status code: ${response.statusCode}';
        return null;
      }
    } catch (e) {
      result.value = 'Error occurred';
      // return {};
    }
  }

  Future getProjectDetails({required int projectId}) async {
    try {
      var data = {'project_id': projectId};

      final response = await API().postRequest(
          route: '/sup/get_project', data: data, token: box.read('token'));

      final decoded = json.decode(response.body);
      if (decoded['data'] != null) {
        // debugPrint(decoded['data'].toString());
        return decoded;
      } else {
        return {};
      }
    } catch (e) {
      result.value = "Error occurred ${e}";
      return {};
    }
  }

  Future submitServiceForm({
    required int serviceId,
    required int userId,
  }) async {
    try {
      String serviceKey = 'service_${serviceId}';
      var data = {
        "user_id": userId,
        "service_id": serviceId,
        "service_data": box.read(serviceKey),
      };
      // debugPrint(box.read(serviceKey).toString());

      final response = await API().postRequest(
        route: '/sup/save_service_data',
        data: data,
        token: box.read("token"),
      );

      if (response.statusCode == 200) {
        result.value = "Form Successfully Submitted.";
        debugPrint(response.body);
        box.remove(serviceKey);
        return true;
      } else if (response.statusCode == 401) {
        debugPrint("401");
        result.value = "Unauthorised Access";
        return false;
      } else {
        result.value = "Server Error! Try Again";
        debugPrint("500");
        debugPrint('${response.body}');
        return false;
      }
    } catch (e) {
      result.value = 'Error Occurred! Try Again';
      return null;
    }
  }
}
