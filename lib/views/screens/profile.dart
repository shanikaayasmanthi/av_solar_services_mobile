import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';
import '../widgets/change_password_widget.dart';
import '../widgets/profile_row_widget.dart';
import '../../controllers/profile.dart';

class Profile extends StatefulWidget {
  final int userId; 

  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController controller = Get.put(ProfileController());
  bool showChangePassword = false;

  @override
  void initState() {
    super.initState();
    controller.loadProfile(userId: widget.userId); // 🔹 use widget.userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.profileData;

          return Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SafeArea(child: SizedBox()),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 90,
                        backgroundImage: AssetImage('lib/images/profile.jpg'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['user_type'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                final nameController = TextEditingController(text: data['name']);
                                final emailController = TextEditingController(text: data['email']);
                                final phoneController = TextEditingController(text: data['phone']);
                                final addressController = TextEditingController(text: data['address']);

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom,
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Edit Profile",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: textBlack,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(labelText: "Name"),
                                          ),
                                          TextField(
                                            controller: emailController,
                                            decoration: const InputDecoration(labelText: "Email"),
                                          ),
                                          TextField(
                                            controller: phoneController,
                                            decoration: const InputDecoration(labelText: "Phone"),
                                          ),
                                          TextField(
                                            controller: addressController,
                                            decoration: const InputDecoration(labelText: "Address"),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () async {
                                              final success = await controller.updateProfile(
                                                userId: data['user_id'],
                                                name: nameController.text,
                                                email: emailController.text,
                                                phone: phoneController.text,
                                                address: addressController.text,
                                              );
                                              if (success && mounted) {
                                                Navigator.pop(context);
                                                Get.snackbar("Success", "Profile updated successfully");
                                              } else {
                                                Get.snackbar("Error", "Failed to update profile");
                                              }
                                            },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: textGreen,
                                                foregroundColor: textWhite,
                                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                elevation: 2,
                                              ),
                                            child: const Text("Save"),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.mode_edit_outline_rounded,
                                color: textGrey,
                                
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 10),
                        ProfileRowWidget(
                          topic: "Email",
                          data: data['email'] ?? "",
                        ),
                        const SizedBox(height: 10),
                        ProfileRowWidget(
                          topic: "Phone No",
                          data: data['phone'] ?? "",
                        ),
                        const SizedBox(height: 10),
                        ProfileRowWidget(
                          topic: "Address",
                          data: data['address'] ?? "Not Provided",
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: textGrey, thickness: 1),
                        const SizedBox(height: 20),
                        const Text(
                          "Security Information",
                          style: TextStyle(
                              color: textBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "Change Password",
                              style: TextStyle(
                                  color: textBlack,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showChangePassword = !showChangePassword;
                                });
                              },
                              icon: Icon(
                                showChangePassword
                                    ? Icons.keyboard_arrow_up_outlined
                                    : Icons.keyboard_arrow_down_outlined,
                                color: textGrey,
                              ),
                            ),
                          ],
                        ),
                        showChangePassword
                            ? const ChangePasswordWidget()
                            : const SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

