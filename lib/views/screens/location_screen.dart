// Core Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// Application-specific imports
import 'package:av_solar_services/constants/colors.dart';
import 'package:av_solar_services/views/widgets/location_widget.dart';
import 'package:av_solar_services/constants/base_url.dart';

class LocationScreen extends StatefulWidget {
  final int projectId;

  const LocationScreen({super.key, required this.projectId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? _lattitude;
  double? _longitude;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final url = Uri.parse('$baseUrl/project-location/${widget.projectId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lattitude = double.tryParse(data['lattitude'].toString());
        final longitude = double.tryParse(data['longitude'].toString());

        if (lattitude != null && longitude != null) {
          setState(() {
            _lattitude = lattitude;
            _longitude = longitude;
            _showMap = true;
          });

          final googleMapsUrl =
              'https://www.google.com/maps/search/?api=1&query=$lattitude,$longitude';

          if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
            await launchUrl(
              Uri.parse(googleMapsUrl),
              mode: LaunchMode.externalApplication,
            );
          } else {
            _showSnackBar("Could not launch Google Maps.");
          }
        }
      } else {
        _showSnackBar("Project not found.");
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  void _showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: Stack(
          children: [
            if (_lattitude != null && _longitude != null && _showMap)
              LocationWidget(
                lattitude: _lattitude!,
                longitude: _longitude!,
                onOpenGoogleMaps: _loadLocation,
              ),
          ],
        ),
      ),
    );
  }
}