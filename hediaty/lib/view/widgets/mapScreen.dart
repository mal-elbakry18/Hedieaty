import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find a Store")),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(30.0444, 31.2357), // Example: Cairo coordinates
          zoom: 14,
        ),
        myLocationEnabled: true,
      ),
    );
  }
}
