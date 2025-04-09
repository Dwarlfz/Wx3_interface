// lib/features/compass/widgets/compass_display.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class CompassDisplay extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double speed;

  const CompassDisplay({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    final gmaps.LatLng position = gmaps.LatLng(latitude, longitude);

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
                    Text('Latitude: ${latitude.toStringAsFixed(5)}'),
                    Text('Longitude: ${longitude.toStringAsFixed(5)}'),
                    Text('Speed: ${speed.toStringAsFixed(2)} m/s'),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: gmaps.GoogleMap(
              initialCameraPosition: gmaps.CameraPosition(
                target: position,
                zoom: 15,
              ),
              markers: <gmaps.Marker>{
                gmaps.Marker(
                  markerId: const gmaps.MarkerId('currentLocation'),
                  position: position,
                ),
              },
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
      ],
    );
  }
}
