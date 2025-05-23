import 'package:flutter/material.dart';

String formatWeatherDescription(String? weatherAPICode) {
  if (weatherAPICode == null) return "No Signal";
  Map<String, String> weatherMap = {
    "Clouds": "Cloudy",
    "Clear": "Clear Sky",
    "Rain": "Rainy",
    "Drizzle": "Drizzling",
    "Thunderstorm": "Stormy",
    "Snow": "Snowy",
    "Mist": "Misty",
    "Fog": "Foggy",
    "Haze": "Hazy",
    "Smoke": "Smoky",
    "Dust": "Dusty",
    "Sand": "Sandy",
    "Ash": "Ashy",
    "Squall": "Windy",
    "Tornado": "Tornado"
  };
  return weatherMap[weatherAPICode] ?? weatherAPICode;
}

Color getWeatherColor(String? weatherMain) {
  switch (weatherMain) {
    case "Clear":
      return Colors.orange;
    case "Clouds":
      return Colors.grey;
    case "Rain":
    case "Drizzle":
      return Colors.blue;
    case "Thunderstorm":
      return Colors.deepPurple;
    case "Snow":
      return Colors.lightBlue;
    default:
      return Colors.grey;
  }
}

IconData getWeatherIcon(String? weatherIcon) {
  switch (weatherIcon) {
    case "01d":
      return Icons.wb_sunny_rounded;
    case "01n":
      return Icons.nightlight_rounded;
    case "02d":
    case "02n":
    case "03d":
    case "03n":
    case "04d":
    case "04n":
      return Icons.cloud_rounded;
    case "09d":
    case "09n":
    case "10d":
    case "10n":
      return Icons.grain_rounded;
    case "11d":
    case "11n":
      return Icons.flash_on_rounded;
    case "13d":
    case "13n":
      return Icons.ac_unit_rounded;
    case "50d":
    case "50n":
      return Icons.filter_drama_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}

String getMonth(int month) {
  List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  return months[month - 1];
}