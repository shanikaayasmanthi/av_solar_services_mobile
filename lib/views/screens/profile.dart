import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/views/widgets/change_password_widget.dart';
import 'package:av_solar_services/views/widgets/profile_row_widget.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showChangePassword =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(children: [
            const SafeArea(
              child: SizedBox(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 90,
                      backgroundImage: AssetImage('lib/images/profile.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        width: 40, // smaller width
                        height: 40, // smaller height
                        decoration: BoxDecoration(
                          color: bgGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: textWhite, width: 2),
                        ),
                        padding: const EdgeInsets.all(4), // smaller padding
                        child: IconButton(
                          onPressed: () {

                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: textWhite,
                            size: 18,
                          ),
                          iconSize: 18, // also can control icon size
                          padding: EdgeInsets.zero, // remove default IconButton padding
                          constraints: const BoxConstraints(), // shrink the IconButton
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Shanika Ayasmanthi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Supervisor',
                  style: TextStyle(
                    fontSize: 18,
                    color: textGrey,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile Information",
                        style: TextStyle(
                            color: textBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(context: context, builder:(BuildContext context){
                              return Container(
                                padding: const EdgeInsets.all(20),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Edit Profile",
                                          style: TextStyle(
                                              color: textBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18
                                          ),),

                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.mode_edit_outline_rounded,
                            color: textGrey,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const ProfileRowWidget(topic: "Email", data: "shanika@gmail.com"),
                  const SizedBox(
                    height: 10,
                  ),
                  const ProfileRowWidget(
                    topic: "Phone No",
                    data: "0717168036",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const ProfileRowWidget(
                      topic: "Address",
                      data: "Kandewatta,Aluthgedara,Deeyagaha,Matara"),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: textGrey,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Security Information",
                    style: TextStyle(
                        color: textBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Change Password",
                        style: TextStyle(color: textBlack,fontSize: 18,
                            fontWeight: FontWeight.bold),),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        setState(() {
                          showChangePassword = !showChangePassword;
                        });
                      }, icon: Icon(showChangePassword?Icons.keyboard_arrow_up_outlined:Icons.keyboard_arrow_down_outlined,color: textGrey,)),
                      // ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //         backgroundColor: bgBlue,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(15),
                      //         )
                      //     ),
                      //     onPressed: (){},
                      //     child: Text("Change Email",style:
                      //     TextStyle(
                      //         color: textWhite
                      //     ),))
                    ],
                  ),
                  showChangePassword?const ChangePasswordWidget():const SizedBox.shrink(),
                ],
              ),
            )
          ]),
        ),
      ),),
    );
  }
}
