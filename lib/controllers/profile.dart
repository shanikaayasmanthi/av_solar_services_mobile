import 'package:av_solar_services/methods/api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Profile extends GetxController{
  final obx = GetStorage();

  Future loadProfile({
    required int userId
}) async{
    try{
      final response = await API().postRequest(
          route: "/profile");
    }catch(e){

    }
}
}