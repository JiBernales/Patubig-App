import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class WeatherService {
  final String _apiKey = '836910daaadaa62acd9d3f662a6d6e0b';

  Future<List<Weather>> fetchWeatherForecast() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      WeatherFactory wf = WeatherFactory(_apiKey, language: Language.ENGLISH);

      List<Weather> forecast = await wf.fiveDayForecastByLocation(
          position.latitude, position.longitude);

      return forecast;
    } catch (e) {
      print("Error fetching weather data: $e");
      rethrow;
    }
  }
}