import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

class MapTheater extends StatefulWidget {
  final String theaeterName;
  const MapTheater({super.key, required this.theaeterName});

  @override
  State<MapTheater> createState() => MapTheaterState();
}

class MapTheaterState extends State<MapTheater> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final LatLng _theaterLocation =
      const LatLng(10.738023187285005, 106.67783119566148);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.738023187285005, 106.67783119566148),
    zoom: 18.54321,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.containerColor),
        backgroundColor: Colors.black.withOpacity(0.3),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: const MarkerId('theater'),
            position: _theaterLocation,
            infoWindow: InfoWindow(
              title: widget.theaeterName,
            ),
          ),
        },
      ),
    );
  }
}
