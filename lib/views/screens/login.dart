import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/controllers/authentication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class Login extends StatefulWidget {
  const Login ({super.key});

  @override
  _LoginState createState()=> _LoginState();
}

class _LoginState extends State<Login>{

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthenticationController _authenticationController = Get.put(AuthenticationController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //logo
                Image.asset("lib/images/avLogo.png",height: 30,),
                const SizedBox(height: 40,),
                const Text("Welcome Back!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5,),
                const Text("Login to access your account",style: TextStyle(color: textGrey),),
                const SizedBox(height: 20,),
                //username & password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: <Widget>[
                      //username
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            hintText: "username",
                            hintStyle: TextStyle(color: textGrey),
                            filled: true,
                            fillColor: bgGrey,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            )
                        ),
                      ),
                      Obx(() {
                        final error = _authenticationController.emailError.value;
                        return error != null
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                            : SizedBox.shrink();
                      }),


                      const SizedBox(height: 20,),
                      //password
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "password",
                          hintStyle: TextStyle(color: textGrey),
                          filled: true,
                          fillColor: bgGrey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          )
                        ),
                      ),
                      Obx(() {
                        final error = _authenticationController.passwordError.value;
                        return error != null
                            ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            error,
                            style: TextStyle(color: textRed),
                          ),
                        )
                            : SizedBox.shrink();
                      }),
                      //forget password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: (){},
                          child: const Text("forget password",
                          style: TextStyle(color: textGrey)),
                        ),
                      ),

                      Obx(() {
                        final error = _authenticationController.result.value;
                        return error != null
                            ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                            : SizedBox.shrink();
                      }),

                      const SizedBox(height: 10,),
                      //login button
                      Obx((){
                        return _authenticationController.isLoading.value
                            ?const CircularProgressIndicator()
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgBlue,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async{

                            final Map<String,dynamic>? loggeduser = await _authenticationController.login(
                                email: _usernameController.text.toString(),
                                password: _passwordController.text.toString());

                            //navigate to home page
                            if (loggeduser != null && loggeduser.isNotEmpty) {
                              debugPrint(loggeduser['user_type'].toString());
                              if(loggeduser['user_type'].toString()=="supervisor"){
                                Get.offAllNamed('sup');
                              }else{
                                Get.snackbar(
                                  "Access denied",
                                  "Try Again",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: bgLightGreen,
                                  colorText: textBlack,
                                );
                                final token = _authenticationController.token.value.toString();
                                _authenticationController.logout(token: token);
                              }
                            }


                            // Navigator.of(context).pushNamed("sup");
                          },
                          child: const Text("Login", style: TextStyle(color: textWhite,fontSize: 16)),

                        );
                      }),
                      const SizedBox(height: 20,),

                      //register page button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Haven't Account     |"),
                          TextButton(
                              onPressed: (){},
                              child: const Text("Sign Up",
                                  style: TextStyle(color: textBlue),))
                        ],
                      )
                    ]
                ),)
              ],
            ),

          ),
      ),
    );
  }

}