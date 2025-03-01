import 'dart:convert';
import 'package:clima/services/location.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String weatherInfo = "Завантаження...";

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    Location location = Location();
    var position = await location.getCurrentLocation();
    if (position != null) {
      fetchWeather(position.latitude, position.longitude);
    }
  }

  void fetchWeather(double latitude, double longitude) async {
    try {
      var data = await getWeather(latitude, longitude);
      setState(() {
        var temperature = data['current_weather']['temperature'];
        weatherInfo = "Температура: $temperature°C";
      });
      print(weatherInfo);
    } catch (e) {
      print("Помилка: $e");
    }
  }

  Future<Map<String, dynamic>> getWeather(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Помилка отримання погоди');
      }
    } catch (e) {
      throw Exception('Не вдалося отримати дані: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Погода")),
      body: Center(
        child: Text(weatherInfo),
      ),
    );
  }
}
