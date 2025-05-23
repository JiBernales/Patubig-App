import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import '../../../core/services/weather_service.dart';
import '../model/weather_forecast_model.dart';

class WeatherCalendarViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  WeatherForecastModel _weatherForecast = WeatherForecastModel(isLoading: true);
  DateTime _selectedDate = DateTime.now();

  WeatherForecastModel get weatherForecast => _weatherForecast;
  DateTime get selectedDate => _selectedDate;

  Future<void> fetchWeather() async {
    _weatherForecast = _weatherForecast.copyWith(isLoading: true);
    notifyListeners();

    try {
      List<Weather> forecast = await _weatherService.fetchWeatherForecast();
      
      _weatherForecast = WeatherForecastModel(
        currentWeather: forecast[0],
        forecast: forecast.sublist(6, 22),
        isLoading: false,
      );
    } catch (e) {
      _weatherForecast = WeatherForecastModel(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  void updateSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}