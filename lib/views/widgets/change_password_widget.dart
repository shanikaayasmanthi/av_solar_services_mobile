import 'package:av_solar_services/controllers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/colors.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());
  final box = GetStorage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obscurecurrpw = true; // initially password is hidden
  bool _obscurenewpw = true;
  bool _obscurenewconfpw = true;
  bool? result;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: textGrey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Current Password"),
                TextFormField(
                  obscureText: _obscurecurrpw,
                  controller: _currPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required*";
                    }
                  },
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurecurrpw
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: textGrey,
                        size: 17,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurecurrpw = !_obscurecurrpw;
                        });
                      },
                    ),
                    hintText: "current password",
                    hintStyle: const TextStyle(color: textGrey),
                    fillColor: bgGrey,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("New Password"),
                TextFormField(
                  obscureText: _obscurenewpw,
                  controller: _newPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required*";
                    } else {
                      if (value == _currPassword.text) {
                        return "New password should not same as current password";
                      }
                    }
                  },
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurenewpw = !_obscurenewpw;
                          });
                        },
                        icon: Icon(
                          _obscurenewpw
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: textGrey,
                          size: 17,
                        )),
                    hintText: "new password",
                    hintStyle: const TextStyle(color: textGrey),
                    fillColor: bgGrey,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Confirm New Password"),
                TextFormField(
                  obscureText: _obscurenewconfpw,
                  controller: _confirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required*";
                    } else {
                      if (value.toString() != _newPassword.text) {
                        return "Doesn't match with above password";
                      }
                    }
                  },
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurenewconfpw = !_obscurenewconfpw;
                          });
                        },
                        icon: Icon(
                          _obscurenewconfpw
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: textGrey,
                          size: 17,
                        )),
                    hintText: "confirm password",
                    hintStyle: const TextStyle(color: textGrey),
                    fillColor: bgGrey,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      final massege = _authenticationController.result.value;
                      return massege != null
                          ? Align(
                              alignment: Alignment.center,
                              child: Text(
                                massege,
                                style: TextStyle(
                                    color: massege
                                            .toLowerCase()
                                            .contains('succesfully')
                                        ? textGreen
                                        : textRed),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
                    Obx(() {
                      return _authenticationController.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: bgBlue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () async {
                                    final isValidate =
                                        _formKey.currentState!.validate();
                                    if (isValidate) {
                                      result = await _authenticationController
                                          .changePassword(
                                              userId: box.read('user')['id'],
                                              oldPassword: _currPassword.text,
                                              newPassword: _newPassword.text,
                                              confPassword:
                                                  _confirmPassword.text);
                                    }

                                    if (result == true) {
                                      setState(() {
                                        _confirmPassword.clear();
                                        _currPassword.clear();
                                        _newPassword.clear();
                                      });
                                      Future.delayed(const Duration(seconds: 3), () {
                                        setState(() {
                                          result = null;
                                        });
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Update Password",
                                    style: TextStyle(color: textWhite),
                                  )),
                            );
                    }),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
