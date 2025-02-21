import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<Position?> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Геолокація вимкнена! Ввімкніть GPS.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Дозвіл на геолокацію відхилено.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          "🚨 Дозвіл на геолокацію заблоковано назавжди! Перейдіть у налаштування.");
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("✅ Локація отримана: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      print("❌ Помилка отримання локації: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
