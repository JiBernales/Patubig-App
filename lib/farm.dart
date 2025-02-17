import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'main.dart';

Future<void> _checkLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("Location services are disabled.");
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permissions are denied.");
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("Location permissions are permanently denied.");
    return;
  }

  print("Location permissions are granted.");
}

class WeatherStatsScreen extends StatefulWidget {
  @override
  _WeatherStatsScreenState createState() => _WeatherStatsScreenState();
}

class _WeatherStatsScreenState extends State<WeatherStatsScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("farm1");
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _databaseRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          _weatherData = Map<String, dynamic>.from(event.snapshot.value as Map);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            _weatherData != null
                ? StatsCard(weatherData: _weatherData!)
                : CircularProgressIndicator(),
            MapCard(),
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  StatsCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stat(icon: Icons.thermostat, label: "Temperature", value: "${weatherData['temperature']}°C", color: weatherData['temperature'] > 35 ? Colors.red : Colors.blue),
          Stat(icon: Icons.water_drop, label: "Humidity", value: "${weatherData['humidity']}%", color: weatherData['humidity'] >= 80 ? Colors.red : weatherData['humidity'] <= 40 ? Colors.black : Colors.blue),
          Stat(icon: weatherData['rainSensor'] == 1 ? Icons.cloudy_snowing : Icons.cloud, label: "Rain", value: weatherData['rainSensor'] == 1 ? "Rain" : "No Rain", color: weatherData['rainSensor'] == 1 ? Colors.blue : Colors.black),
          Stat(icon: Icons.waves, label: "Water Lvl.", value: "${weatherData['waterLevel']} cm", color: weatherData['waterLevel'] > 0 ? Colors.blueAccent : Colors.black),
        ],
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  Stat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.175,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize:
          8, color: Colors.grey)),
        ],
      ),
    );
  }
}

class MapCard extends StatefulWidget {
  @override

  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
        ),
      ),
    );
  }
}
