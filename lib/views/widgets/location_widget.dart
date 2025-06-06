import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class LocationWidget extends StatefulWidget {
  final double latittude;
  final double longitude;

  const LocationWidget({
    super.key,
    required this.latittude,
    required this.longitude,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  late GoogleMapController _mapController;
  late CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();

    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }

    _initialPosition = CameraPosition(
      target: LatLng(widget.latittude, widget.longitude),
      zoom: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId('project_location'),
            position: LatLng(widget.latittude, widget.longitude),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
      ),
    );
  }
}
