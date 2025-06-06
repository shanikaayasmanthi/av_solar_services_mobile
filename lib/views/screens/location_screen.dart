import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:av_solar_services/views/widgets/location_widget.dart'; // <-- your custom map widget

class LocationScreen extends StatefulWidget {
  final int projectId;

  const LocationScreen({super.key, required this.projectId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? _latittude;
  double? _longitude;
  bool _showMap = false;

  Future<void> _openMapWithProjectLocation(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/project-location/${widget.projectId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latittude = data['latittude'];
        final longitude = data['longitude'];

        setState(() {
          _latittude = double.tryParse(latittude.toString());
          _longitude = double.tryParse(longitude.toString());
        });

        /// Delay map render until after current frame is drawn
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _showMap = true;
            });
          }
        });

        final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latittude,$longitude';

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not launch Google Maps")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Project not found")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (_latittude != null && _longitude != null && _showMap)
              LocationWidget(latittude: _latittude!, longitude: _longitude!),
            Positioned(
              top: 16,
              left: 16,
              child: ElevatedButton(
                onPressed: () => _openMapWithProjectLocation(context),
                child: const Text('Open in Google Maps'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
 