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
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            WeatherForecastCard(),
            SizedBox(height: 16),
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
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    String key = '836910daaadaa62acd9d3f662a6d6e0b';
    try {
      Position position = await Geolocator.getCurrentPosition();
      WeatherFactory wf = WeatherFactory(key, language: Language.ENGLISH);

      List<Weather> forecast = await wf.fiveDayForecastByLocation(
          position.latitude, position.longitude);

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              "Weather Forecast",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.agriculture_rounded,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FarmID00111",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Rice Field - Palay",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTodayWeather(today),
                        ),
                        if (_forecast != null && _forecast!.length > 15) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                WeatherDay(
                                  day: DateFormat('EEE').format(_forecast![0].date!),
                                  label: formatWeatherDescription(_forecast![0].weatherMain),
                                  icon: _getWeatherIcon(_forecast![0].weatherIcon),
                                  isCompact: true,
                                ),
                                WeatherDay(
                                  day: DateFormat('EEE').format(_forecast![7].date!),
                                  label: formatWeatherDescription(_forecast![7].weatherMain),
                                  icon: _getWeatherIcon(_forecast![7].weatherIcon),
                                  isCompact: true,
                                ),
                                WeatherDay(
                                  day: DateFormat('EEE').format(_forecast![15].date!),
                                  label: formatWeatherDescription(_forecast![15].weatherMain),
                                  icon: _getWeatherIcon(_forecast![15].weatherIcon),
                                  isCompact: true,
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWeather(String today) {
    return Column(
      children: [
        Text(
          today,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            _getWeatherIcon(_weather?.weatherIcon),
            size: 60,
            color: _getWeatherColor(_weather?.weatherMain),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          formatWeatherDescription(_weather?.weatherMain),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (_weather?.temperature?.celsius != null) ...[
          const SizedBox(height: 4),
          Text(
            "${_weather!.temperature!.celsius!.round()}°C",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Color _getWeatherColor(String? weatherMain) {
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

  IconData _getWeatherIcon(String? weatherIcon) {
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
}

class WeatherDay extends StatelessWidget {
  final String day;
  final String label;
  final IconData icon;
  final bool isCompact;

  const WeatherDay({
    super.key,
    required this.day,
    required this.label,
    required this.icon,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isCompact ? 4 : 8),
          Icon(
            icon,
            size: isCompact ? 20 : 30,
            color: Colors.black87,
          ),
          SizedBox(height: isCompact ? 4 : 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isCompact ? 8 : 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              "Planting Schedule",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4CAF50),
                          Color(0xFF81C784),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.pexels.com/photos/265216/pexels-photo-265216.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          ),
                          fit: BoxFit.cover,
                          opacity: 0.7,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 119, 4).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Planting Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _getMonth(selectedDate.month),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              "${selectedDate.day}",
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => _pickDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_calendar_rounded,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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