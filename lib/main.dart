import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GeoLocationCordinated(),
    );
  }
}

class GeoLocationCordinated extends StatefulWidget {
  const GeoLocationCordinated({super.key});

  @override
  State<GeoLocationCordinated> createState() => _GeoLocationCordinatedState();
}

class _GeoLocationCordinatedState extends State<GeoLocationCordinated> {
  String localMessage = "Find location";
  late String lat;
  late String long;

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, proceed with getting location
      getLocationCordinate();
    } else if (status.isDenied) {
      // Permission denied
      setState(() {
        localMessage = "Location permission denied";
      });
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      openAppSettings();
    }
  }

  Future<void> getLocationCordinate() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        localMessage = "Location services are disabled";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        localMessage = "Location permission denied";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      lat = '${position.latitude}';
      long = '${position.longitude}';
      setState(() {
        localMessage = 'Latitude: $lat, Longitude: $long';
      });
    } catch (e) {
      setState(() {
        localMessage = "Failed to get location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Location Coordinates"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localMessage),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                requestLocationPermission();
              },
              child: const Text("Find location"),
            ),
          ],
        ),
      ),
    );
  }
}
