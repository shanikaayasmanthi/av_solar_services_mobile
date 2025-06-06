import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  final int projectId;

  const LocationScreen({super.key, required this.projectId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LatLng? _projectLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _fetchProjectLocation();
  }

  Future<void> _fetchProjectLocation() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/project-location/${widget.projectId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = double.tryParse(data['latittude'].toString());
        final lng = double.tryParse(data['longitude'].toString());

        if (lat != null && lng != null && mounted) {
          setState(() {
            _projectLocation = LatLng(lat, lng);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Project not found")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _openMapWithProjectLocation(BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/project-location/${widget.projectId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = data['latittude'];
        final lng = data['longitude'];

        final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

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
            // Map as background
            _projectLocation != null
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _projectLocation!,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('projectLocation'),
                        position: _projectLocation!,
                      ),
                    },
                  )
                : const Center(child: CircularProgressIndicator()),

            // Top-left location button
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
