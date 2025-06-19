// Core Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

// Application-specific imports
import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/views/widgets/location_widget.dart';
import 'package:av_solar_services/controllers/location.dart';

class LocationScreen extends StatefulWidget {
  final int projectId;

  const LocationScreen({super.key, required this.projectId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    locationController.getLocation(projectId: widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: Obx(() => Stack(
          children: [
            if (locationController.lattitude.value != null &&
                locationController.longitude.value != null)
              LocationWidget(
                lattitude: locationController.lattitude.value!,
                longitude: locationController.longitude.value!,
                onOpenGoogleMaps: () async {
                  final googleMapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=${locationController.lattitude.value},${locationController.longitude.value}';
                  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                    await launchUrl(
                      Uri.parse(googleMapsUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    locationController.showSnackBar(
                        "Could not launch Google Maps.");
                  }
                },
              ),
            if (locationController.result.value != null)
              Center(
                child: Text(
                  locationController.result.value!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        )),
      ),
    );
  }
}