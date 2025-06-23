import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/views/widgets/profile_row_widget.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _currPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obscurecurrpw = true; // initially password is hidden
  bool _obscurenewpw = true;
  bool _obscurenewconfpw = true;
  @override
  Widget build(BuildContext context) {
    return Align(
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
                    CircleAvatar(
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
                          icon: Icon(
                            Icons.camera_alt,
                            color: textWhite,
                            size: 18,
                          ),
                          iconSize: 18, // also can control icon size
                          padding: EdgeInsets.zero, // remove default IconButton padding
                          constraints: BoxConstraints(), // shrink the IconButton
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
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Profile Information",
                        style: TextStyle(
                            color: textBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: textGrey,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileRowWidget(topic: "Email", data: "shanika@gmail.com"),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileRowWidget(
                    topic: "Phone No",
                    data: "0717168036",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileRowWidget(
                      topic: "Address",
                      data: "Kandewatta,Aluthgedara,Deeyagaha,Matara"),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: textGrey,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Security Information",
                    style: TextStyle(
                        color: textBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: bgBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 40),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            "Chenge Password",
                                            style: TextStyle(
                                                color: textBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text("Current Password"),
                                            SizedBox(
                                              height: 45,
                                              child: TextFormField(
                                                obscureText: _obscurecurrpw,
                                                controller: _currPassword,
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
                                                  hintStyle: const TextStyle(
                                                      color: textGrey),
                                                  fillColor: bgGrey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text("New Password"),
                                            SizedBox(
                                              height: 45,
                                              child: TextFormField(
                                                obscureText: _obscurenewpw,
                                                controller: _newPassword,
                                                onChanged: (value) {},
                                                decoration: InputDecoration(
                                                  suffixIcon: IconButton(onPressed: (){
                                                    setState(() {
                                                      _obscurenewpw =!_obscurenewpw;
                                                    });
                                                  }, icon: Icon(_obscurenewpw? Icons.visibility_off:Icons.visibility,
                                                  color: textGrey,
                                                  size: 17,)),
                                                  hintText: "new password",
                                                  hintStyle: const TextStyle(
                                                      color: textGrey),
                                                  fillColor: bgGrey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text("Confirm New Password"),
                                            SizedBox(
                                              height: 45,
                                              child: TextFormField(
                                                obscureText: _obscurenewconfpw,
                                                controller: _confirmPassword,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _obscurenewconfpw =!_obscurenewconfpw;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  suffixIcon: IconButton(onPressed: (){}, icon: Icon(_obscurenewconfpw?Icons.visibility_off:Icons.visibility,color: textGrey,size: 17,)),
                                                  hintText: "confirm password",
                                                  hintStyle: const TextStyle(
                                                      color: textGrey),
                                                  fillColor: bgGrey,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: bgBlue,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15))),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      "Change",
                                                      style: TextStyle(
                                                          color: textWhite),
                                                    ))
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            "Change Password",
                            style: TextStyle(color: textWhite),
                          )),
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
                  )
                ],
              ),
            )
          ]),
        ));
  }
}
