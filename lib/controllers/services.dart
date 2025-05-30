import 'dart:convert';

import 'package:av_solar_services/methods/api.dart';
import 'package:av_solar_services/models/Service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ServicesController extends GetxController{

  final isLoading = false.obs;
  final result = RxnString();

  final box = GetStorage();

  Future <List<Service>> getServices(
  {
    required int userId,
}
      ) async{
    try {
      if(box.read('token')!=null){
        var data = {
          'user_id':userId
        };
        final response =await API().postRequest(
            route: '/sup/services',
            data: data,
            token: box.read('token').toString()
        );

        if(response.statusCode == 200){
          // debugPrint(response.body);
          isLoading.value=false;
          // debugPrint(json.decode(response.body));
          final decoded = json.decode(response.body);
          // debugPrint(decoded["data"]);
          final List<dynamic> serviceList = decoded["data"]["Services"];
          return serviceList.map((e) => Service.fromJson(e)).toList();
      }else{
          result.value = 'Something went Wrong';
          return [];
        }

      }else{
       result.value = 'Something went Wrong';
       return [];
      }
    } catch(e){
      print(('Error$e'));
      result.value = 'An Error Occurred';
      return [];
    }
  }
}