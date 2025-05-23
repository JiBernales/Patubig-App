import 'package:weather/weather.dart';

class WeatherForecastModel {
  final Weather? currentWeather;
  final List<Weather>? forecast;
  final bool isLoading;
  final String? error;

  WeatherForecastModel({
    this.currentWeather,
    this.forecast,
    this.isLoading = false,
    this.error,
  });

  WeatherForecastModel copyWith({
    Weather? currentWeather,
    List<Weather>? forecast,
    bool? isLoading,
    String? error,
  }) {
    return WeatherForecastModel(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}