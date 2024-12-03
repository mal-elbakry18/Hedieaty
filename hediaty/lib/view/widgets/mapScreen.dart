import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find a Store")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(30.0444, 31.2357), // Example: Cairo coordinates
          zoom: 14,
        ),
        myLocationEnabled: true,
      ),
    );
  }
}
