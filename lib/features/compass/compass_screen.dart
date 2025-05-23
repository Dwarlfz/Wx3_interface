// lib/features/compass/compass_screen.dart

import 'package:flutter/material.dart';
import 'package:wx3_interface/widgets/custom_app_bar.dart';
import 'package:wx3_interface/widgets/bottom_nav_bar.dart';
import 'package:wx3_interface/features/compass/widgets/compass_display.dart';
import 'package:wx3_interface/core/services/gps_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  int selectedIndex = 1;
  final GpsService gpsService = GpsService();
  DatabaseReference? get databaseRef {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return FirebaseDatabase.instance.ref("route_history/${user.uid}");
  }

  Position? currentPosition;
  Position? lastPosition;
  double speed = 0;
  GoogleMapController? mapController;
  bool isMapExpanded = false;
  MapType currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  final List<LatLng> _routeHistory = [];
  StreamSubscription<Position>? positionStream;
  double totalDistance = 0.0;
  double? _heading;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _startTracking();
    _listenToFirebaseRouteHistory();
    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading;
      });
    });
  }

  void _requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required.')),
      );
    }
  }

  void _listenToFirebaseRouteHistory() {
    final ref = databaseRef;
    if (ref == null) return;

    ref.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final updatedRoute = data.values.map((entry) {
          final map = Map<String, dynamic>.from(entry);
          return LatLng(map['latitude'], map['longitude']);
        }).toList();

        setState(() {
          _routeHistory.clear();
          _routeHistory.addAll(updatedRoute);
        });
      }
    });
  }

  void _startTracking() async {
    final position = await gpsService.getCurrentLocation();
    setState(() {
      currentPosition = position;
      _routeHistory.add(LatLng(position.latitude, position.longitude));
      _markers.add(
        Marker(
          markerId: const MarkerId('initial_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Start Position'),
        ),
      );
    });

    const locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5);
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position newPosition) {
      if (!mounted) return;

      setState(() {
        lastPosition = currentPosition;
        currentPosition = newPosition;
        _routeHistory.add(LatLng(newPosition.latitude, newPosition.longitude));

        if (lastPosition != null) {
          speed = gpsService.calculateSpeed(lastPosition!, newPosition);
          totalDistance += Geolocator.distanceBetween(
            lastPosition!.latitude,
            lastPosition!.longitude,
            newPosition.latitude,
            newPosition.longitude,
          );
        }

        _markers.add(
          Marker(
            markerId: MarkerId(DateTime.now().toIso8601String()),
            position: LatLng(newPosition.latitude, newPosition.longitude),
            infoWindow: const InfoWindow(title: 'Current Position'),
          ),
        );

        databaseRef?.push().set({
          'latitude': newPosition.latitude,
          'longitude': newPosition.longitude,
          'timestamp': newPosition.timestamp?.toIso8601String() ?? DateTime.now().toIso8601String()
        });

        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLng(
            LatLng(newPosition.latitude, newPosition.longitude),
          ));
        }
      });
    });
  }

  Future<void> _exportRouteAsGpx() async {
    try {
      final directory = await getExternalStorageDirectory();
      final downloadsDir = Directory("/storage/emulated/0/Download");
      final file = File('${downloadsDir.path}/route.gpx');

      final gpxData = '''<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="WX3">
<trk><name>Route</name><trkseg>
${_routeHistory.map((point) => '<trkpt lat="${point.latitude}" lon="${point.longitude}" />').join('\n')}
</trkseg></trk>
</gpx>''';

      await file.writeAsString(gpxData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route exported to ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export: $e')),
      );
    }
  }

  void _clearHistory() {
    setState(() {
      _routeHistory.clear();
      _markers.clear();
      totalDistance = 0;
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  void onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/sensors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Compass',
            onProfileTap: () => Navigator.pushNamed(context, '/profile'),
            onSettingsTap: () => Navigator.pushNamed(context, '/settings'),
            alertMessages: const [],
          ),
          Expanded(
            child: currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                CompassDisplay(
                  latitude: currentPosition!.latitude,
                  longitude: currentPosition!.longitude,
                  speed: speed,
                  compassHeading: _heading,
                ),
                Text('Distance: ${totalDistance.toStringAsFixed(2)} meters'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GoogleMap(
                            onMapCreated: (controller) => mapController = controller,
                            mapType: currentMapType,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                currentPosition!.latitude,
                                currentPosition!.longitude,
                              ),
                              zoom: isMapExpanded ? 18 : 15,
                            ),
                            markers: _markers,
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId('route'),
                                color: Colors.blue,
                                width: 4,
                                points: _routeHistory,
                              ),
                            },
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Column(
                            children: [
                              FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isMapExpanded = !isMapExpanded;
                                    if (mapController != null) {
                                      mapController!.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: LatLng(
                                              currentPosition!.latitude,
                                              currentPosition!.longitude,
                                            ),
                                            zoom: isMapExpanded ? 18 : 15,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Icon(
                                  isMapExpanded ? Icons.zoom_out_map : Icons.zoom_in_map,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    currentMapType = currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
                                  });
                                },
                                child: Icon(
                                  Icons.map,
                                  color: currentMapType == MapType.satellite ? Colors.blue : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                onPressed: _exportRouteAsGpx,
                                child: const Icon(Icons.save, color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                onPressed: _clearHistory,
                                child: const Icon(Icons.clear, color: Colors.red),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
