import 'package:av_solar_services/constants/colors.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
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
                    backgroundImage: AssetImage(
                        'lib/images/profile.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: textWhite, width: 2),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.camera_alt,
                        color: textWhite,
                        size: 18,
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
                'shanika@gmail.com',
                style: TextStyle(
                  fontSize: 18,
                  color: textGrey,
                ),
              )
            ],
          ),
        ]));
  }
}
