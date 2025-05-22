import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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
  const WeatherStatsScreen({super.key});

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
                : const CircularProgressIndicator(),
            const MapCard(),
          ],
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  const StatsCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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

  const Stat({super.key, required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.175,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize:
          8, color: Colors.grey)),
        ],
      ),
    );
  }
}

class MapCard extends StatefulWidget {
  const MapCard({super.key});

  @override

  _MapCardState createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  late MapController _mapController;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentPosition = const LatLng(10.866519, 122.729620);
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _zoomIn() {
    double currentZoom = _mapController.camera.zoom;
  _mapController.move(LatLng(_currentPosition.latitude, _currentPosition.longitude), currentZoom + 0.5);
  }

  void _zoomOut() {
    double currentZoom = _mapController.camera.zoom;
  _mapController.move(LatLng(_currentPosition.latitude, _currentPosition.longitude), currentZoom - 0.5);
  }

  void _centerOnMarker() {
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
          ],
        ),
        child: _currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 14.0,
                  maxZoom: 20.5,
                  minZoom: 11.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                      ),
                      const Marker(
                        point: LatLng(10.869182, 122.728615),
                        child: Icon(Icons.sensors, color: Colors.red),
                      ),
                      const Marker(
                        point: LatLng(10.865102, 122.734650),
                        child: Icon(Icons.sensors, color: Colors.red),
                      ),
                      const Marker(
                        point: LatLng(10.862329, 122.726496),
                        child: Icon(Icons.sensors, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 75,
                right: 10,
                child: FloatingActionButton(
                    onPressed: _zoomIn,
                  backgroundColor: Colors.white, child: const Icon(Icons.add, color: Colors.black,),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                    onPressed: _zoomOut,
                    backgroundColor: Colors.white, child: const Icon(Icons.remove, color: Colors.black,),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
