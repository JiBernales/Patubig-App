import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

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

class WeatherCalendarScreen extends StatelessWidget {
  const WeatherCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const SafeArea(
        child: Column(
          children: [
            WeatherForecastCard(),
            PlantingDateCard(),
          ],
        ),
      ),
    );
  }
}

class WeatherForecastCard extends StatefulWidget {
  const WeatherForecastCard({super.key});

  @override
  _WeatherForecastCardState createState() => _WeatherForecastCardState();
}

class _WeatherForecastCardState extends State<WeatherForecastCard> {
  Weather? _weather;
  List<Weather>? _forecast;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _checkLocationPermission();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    String key = '836910daaadaa62acd9d3f662a6d6e0b';
    int x = 0;
    try {
      Position position = await Geolocator.getCurrentPosition();
      WeatherFactory wf = WeatherFactory(key, language: Language.ENGLISH);

      List<Weather> forecast = await wf.fiveDayForecastByLocation(
          position.latitude, position.longitude);

      /*print("\n====== WEATHER FORECAST DATA ======");
      for (Weather weather in forecast) {
        print(
            "Date: ${DateFormat('yyyy-MM-dd – HH:mm').format(weather.date!)}\n"
                "Condition: ${weather.weatherMain}\n"
                "Description: ${weather.weatherDescription}\n" + x.toString()
        );
        x++;
      }*/

      setState(() {
        _weather = forecast[0];
        _forecast = forecast.sublist(6, 22);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching weather data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                const Icon(Icons.cloud, size: 24),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("FarmID00111", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Palay", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0025),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(_isLoading ? "" :today, textAlign: TextAlign.center),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Icon(
                        _getWeatherIcon(_weather?.weatherIcon),
                        size: 70,
                        color: Colors.black,
                      ),
                      Text(
                        _isLoading ? "" : formatWeatherDescription(_weather?.weatherMain),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (_forecast != null && _forecast!.length > 2)...[
                    Column(
                      children: [
                        WeatherDay(
                          day: DateFormat('EEE').format(_forecast![0].date!),
                          label: formatWeatherDescription(_forecast![0].weatherMain),
                          icon: _getWeatherIcon(_forecast![0].weatherIcon),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        WeatherDay(
                          day: DateFormat('EEE').format(_forecast![7].date!),
                          label: formatWeatherDescription(_forecast![7].weatherMain),
                          icon: _getWeatherIcon(_forecast![7].weatherIcon),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        WeatherDay(
                          day: DateFormat('EEE').format(_forecast![15].date!),
                          label: formatWeatherDescription(_forecast![15].weatherMain),
                          icon: _getWeatherIcon(_forecast![15].weatherIcon),
                        ),
                      ],
                    )
                  ]
                ]
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String? weatherIcon) {
    switch (weatherIcon) {
      case "01d":
        return Icons.wb_sunny;
      case "01n":
        return Icons.nightlight_round;
      case "02d":
      case "02n":
      case "03d":
      case "03n":
      case "04d":
      case "04n":
        return Icons.cloud;
      case "09d":
      case "09n":
      case "10d":
      case "10n":
        return Icons.grain;
      case "11d":
      case "11n":
        return Icons.flash_on;
      case "13d":
      case "13n":
        return Icons.ac_unit;
      case "50d":
      case "50n":
        return Icons.filter_drama;
      default:
        return Icons.help_outline;
    }
  }
}

class WeatherDay extends StatelessWidget {
  final String day;
  final String label;
  final IconData icon;

  const WeatherDay({super.key, required this.day, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day),
        Container(
          child: Icon(icon, size: 30, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class PlantingDateCard extends StatefulWidget {
  const PlantingDateCard({super.key});

  @override
  _PlantingDateCardState createState() => _PlantingDateCardState();
}

class _PlantingDateCardState extends State<PlantingDateCard> {
  DateTime selectedDate = DateTime.now();

  Future<void> _pickDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    setState(() {
      selectedDate = newDate!;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://images.pexels.com/photos/265216/pexels-photo-265216.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Started Planting",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _getMonth(selectedDate.month),
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${selectedDate.day}",
                      style:
                      const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _pickDate(context),
                child: const Icon(Icons.edit, color: Colors.blue, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }
}