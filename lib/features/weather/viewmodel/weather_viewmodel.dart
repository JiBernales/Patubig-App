import 'package:flutter/material.dart';
import '../model/weather_model.dart';

class WeatherViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<WeatherModel> weatherData = [];

  WeatherViewModel() {
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulated fetch
    weatherData = [
      WeatherModel(date: 'May 23', temperature: 32.0),
      WeatherModel(date: 'May 24', temperature: 30.5),
    ];
    isLoading = false;
    notifyListeners();
  }
}
