import 'dart:convert';

import 'package:av_solar_services/methods/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final emailError = RxnString();
  final passwordError = RxnString();
  final result = RxnString();

  final token = ''.obs;
  final box = GetStorage();


  //login function
  Future login(
  {
    required String email,
    required String password,
}



      ) async {
    try {

      // email validation
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      if (email.isEmpty) {
        emailError.value = 'Required*';
      } else if (!emailRegex.hasMatch(email)) {
        emailError.value = 'Invalid email format';
      } else {
        emailError.value = null;
      }

      //password validation
      if (password.isEmpty) {
        passwordError.value = 'Required*';
      } else {
        passwordError.value = null;
      }

      //call login api when validations are correct
      if(emailError.value==null && passwordError.value==null){
        isLoading.value = true;
        var data = {
          'email': email,
          'password': password,
        };

        debugPrint(data['email']);
        debugPrint(data['password']);

        result.value=null;
        final response = await API().postRequest(route: '/login', data: data);

        if (response.statusCode == 200) {
          debugPrint(response.body);
          isLoading.value = false;
          final decoded = json.decode(response.body);
          debugPrint(decoded["data"]["token"]);
          token.value = decoded["data"]["token"].toString();
          box.write(
            'token', token.value,
          );
          var user = decoded["data"]["user"];
          box.write('user', user);
          // result.value = 'Login successfully';
          return decoded["data"]["user"];
        } else if(response.statusCode == 500){
          isLoading.value = false;
          result.value = 'An Error Occurred!, Try Again';
          // return result.value;
        } else{
          debugPrint(response.body);
          isLoading.value = false;
          final decoded = json.decode(response.body);
          result.value = 'Credentials do not match!';
          // return 'Credentials do not match';
        }
      }

    }catch(e){
      print('Error$e');
      result.value = 'Check your connection';
    }
    }

    //logout function
  Future logout({
    required String token
})async{
    try{
      final response = await API().postRequest(
          route: '/logout',
          token: token
          );
      if(response.statusCode == 200){
        return true;
      }
    }catch(e){}
  }
}
