import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;
  Location({
    this.latitude,
    this.longitude,
  });

  Future<Position?> getCurrentLocation() async {
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
      latitude = position.latitude;
      longitude = position.longitude;
      print("✅ Локація отримана: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      print("❌ Помилка отримання локації: $e");
      return null;
    }
  }
}
