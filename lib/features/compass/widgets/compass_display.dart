// lib/features/compass/widgets/compass_display.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:permission_handler/permission_handler.dart';

class CompassDisplay extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double speed;
  final double? compassHeading;

  const CompassDisplay({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.speed,
    this.compassHeading,
  });

  @override
  State<CompassDisplay> createState() => _CompassDisplayState();
}

class _CompassDisplayState extends State<CompassDisplay> {
  gmaps.GoogleMapController? _mapController;
  late gmaps.LatLng _position;

  @override
  void initState() {
    super.initState();
    _position = gmaps.LatLng(widget.latitude, widget.longitude);
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Permission.locationWhenInUse.request();
  }

  void _onMapCreated(gmaps.GoogleMapController controller) {
    _mapController = controller;
  }

  void _centerMap() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        gmaps.CameraUpdate.newLatLng(_position),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude: ${widget.latitude.toStringAsFixed(5)}'),
                    Text('Longitude: ${widget.longitude.toStringAsFixed(5)}'),
                    Text('Speed: ${widget.speed.toStringAsFixed(2)} m/s'),
                    if (widget.compassHeading != null)
                      Text('Heading: ${widget.compassHeading!.toStringAsFixed(2)}°'),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset('lib/assets/lottie/compass.json'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: gmaps.GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: gmaps.CameraPosition(
                    target: _position,
                    zoom: 15,
                  ),
                  markers: <gmaps.Marker>{
                    gmaps.Marker(
                      markerId: const gmaps.MarkerId('currentLocation'),
                      position: _position,
                    ),
                  },
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton.small(
                  backgroundColor: Colors.white,
                  onPressed: _centerMap,
                  child: const Icon(Icons.my_location, color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
