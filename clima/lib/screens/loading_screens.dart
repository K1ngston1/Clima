import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Геолокація вимкнена! Ввімкніть GPS.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Дозвіл на геолокацію відхилено.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          "🚨 Дозвіл на геолокацію заблоковано назавжди! Перейдіть у налаштування.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print("✅ Локація отримана: ${position.latitude}, ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              getLocation();
            });
          },
          child: Text('Get Location'),
        ),
      ),
    );
  }
}
