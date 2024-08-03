import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';

class MapTheater extends StatefulWidget {
  final String theaterName;
  const MapTheater({super.key, required this.theaterName});

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
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: Common.customAppbar(context,null, '', AppColors.iconThemeColor,
          AppColors.appbarColor.withOpacity(0.1)),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: const MarkerId('theater'),
            position: _theaterLocation,
            infoWindow: InfoWindow(
              title: widget.theaterName,
            ),
          ),
        },
      ),
    );
  }
}
