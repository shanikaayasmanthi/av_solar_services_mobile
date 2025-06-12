// Core Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemUiOverlayStyle

// Package imports
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:av_solar_services/constants/colors.dart';

class LocationWidget extends StatefulWidget {
  final double lattitude;
  final double longitude;
  final VoidCallback onOpenGoogleMaps;

  const LocationWidget({
    super.key,
    required this.lattitude,
    required this.longitude,
    required this.onOpenGoogleMaps,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late GoogleMapController _mapController;
  String? _currentLocation;
  String? _projectLocation;
  List<LatLng> _routePoints = []; // State variable for route points
  bool _showDirection = false; // State to toggle direction display
  String _distance = 'Distance not available'; // State for distance

  @override
  void initState() {
    super.initState();
    final mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
    _updateLocations();
    _getCurrentLocation(); // Trigger initial location fetch
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location permission denied")),
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permissions are permanently denied, please enable them in settings")),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _currentLocation = '${position.latitude}, ${position.longitude}';
          print('Current Location: $_currentLocation'); // Debug log
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error getting location: ${e.toString()}")),
        );
      }
    }
  }

  void _updateLocations() {
    setState(() {
      _projectLocation = '${widget.lattitude}, ${widget.longitude}';
    });
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Current location not available")),
        );
      }
      return;
    }

    final currentLatLng = _currentLocation!.split(', ').map(double.parse).toList();
    // Replace YOUR_API_KEY with the key from AndroidManifest.xml
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLatLng[0]},${currentLatLng[1]}&destination=${widget.lattitude},${widget.longitude}&mode=driving&key=com.google.android.geo.API_KEY'; // Ensure this key matches AndroidManifest.xml

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Full API Response: $data'); // Detailed debug log
        if (data['status'] == 'OK') {
          final List<LatLng> points = _decodePolyLine(data['routes'][0]['overview_polyline']['points']);
          if (points.isNotEmpty) {
            if (mounted) {
              setState(() {
                _routePoints = points;
                _showDirection = true; // Enable direction display
                // Enhanced distance extraction with detailed debugging
                print('Routes: ${data['routes']?.length}, Legs: ${data['routes']?[0]['legs']?.length}');
                if (data['routes'] != null && data['routes'].isNotEmpty && 
                    data['routes'][0]['legs'] != null && data['routes'][0]['legs'].isNotEmpty &&
                    data['routes'][0]['legs'][0]['distance'] != null && 
                    data['routes'][0]['legs'][0]['distance']['text'] != null) {
                  _distance = data['routes'][0]['legs'][0]['distance']['text'];
                  print('Distance extracted: $_distance');
                } else {
                  _distance = 'Distance not available';
                  print('Distance data missing or invalid structure in API response');
                }
              });
              _updateCamera();
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No route found")),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("API Error: ${data['status']}")),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to load route: ${response.statusCode}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching route: ${e.toString()}")),
        );
      }
    }
  }

  List<LatLng> _decodePolyLine(String poly) {
    List<LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  void _updateCamera() {
    if (_routePoints.isEmpty || _currentLocation == null) return;

    final List<String> currentCoords = _currentLocation!.split(', ');
    final LatLng currentLatLng = LatLng(double.parse(currentCoords[0]), double.parse(currentCoords[1]));
    final LatLng projectLatLng = LatLng(widget.lattitude, widget.longitude);
    final LatLngBounds bounds = _createBounds(currentLatLng, projectLatLng);
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _createBounds(LatLng point1, LatLng point2) {
    final double southWestLatitude = [point1.latitude, point2.latitude].reduce((a, b) => a < b ? a : b);
    final double southWestLongitude = [point1.longitude, point2.longitude].reduce((a, b) => a < b ? a : b);
    final double northEastLatitude = [point1.latitude, point2.latitude].reduce((a, b) => a > b ? a : b);
    final double northEastLongitude = [point1.longitude, point2.longitude].reduce((a, b) => a > b ? a : b);
    return LatLngBounds(
      southwest: LatLng(southWestLatitude, southWestLongitude),
      northeast: LatLng(northEastLatitude, northEastLongitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: bgGreen, // Set status bar background to bgGreen
        statusBarIconBrightness: Brightness.light, // Ensure icons are visible (e.g., white)
      ),
      child: Stack(
        children: [
          // Green area above app bar
          Container(
            height: 20.0, // Adjust height as needed
            color: bgGreen,
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: bgLightGreen,
              title: const Text(
                'Project Location',
                style: TextStyle(
                  fontSize: 20.0, // Increased text size
                  color: textBlack, // Changed text color to white
                ),
              ),
              elevation: 0, // Remove shadow to blend with green area
            ),
            body: Column(
              children: [
                // Top panel with location text boxes
                Container(
                  padding: const EdgeInsets.all(12.0),
                  color: bgWhite,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: bgBlue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: _currentLocation ?? 'Not Available'),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: bgWhite,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: bgGrey, width: 1.5),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.pin_drop, color: textRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: _projectLocation ?? 'Loading...'),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: bgWhite,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: bgGrey, width: 1.5),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Map box with adjusted starting point and buttons
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentLocation != null ? _currentLocation!.split(', ').map(double.parse).toList().asMap().entries.map((e) => LatLng(e.value, e.value)).first : LatLng(widget.lattitude, widget.longitude),
                            zoom: 15,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                            if (_showDirection && _routePoints.isNotEmpty) _updateCamera();
                          },
                          markers: {
                            if (_currentLocation != null)
                              Marker(
                                markerId: const MarkerId('current_location'),
                                position: _currentLocation!.split(', ').map(double.parse).toList().asMap().entries.map((e) => LatLng(e.value, e.value)).first,
                              ),
                            Marker(
                              markerId: const MarkerId('project_location'),
                              position: LatLng(widget.lattitude, widget.longitude),
                            ),
                          },
                          polylines: _showDirection && _routePoints.isNotEmpty
                              ? {
                                  Polyline(
                                    polylineId: const PolylineId('route'),
                                    points: _routePoints,
                                    color: bgBlue,
                                    width: 5,
                                  ),
                                }
                              : {},
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (_currentLocation != null) _fetchRoute();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bgGreen,
                                  foregroundColor: bgWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Direction'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: widget.onOpenGoogleMaps,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bgGreen,
                                  foregroundColor: bgWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Open with Google Maps'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Distance display below map
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _distance,
                    style: const TextStyle(fontSize: 14, color: textGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}