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
    _databaseRef
        .orderByKey()
        .limitToLast(1)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final Map<String, dynamic> readings =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        final latestReading = readings.values.first as Map;
        setState(() {
          _weatherData = Map<String, dynamic>.from(latestReading);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          // Good to have for responsiveness
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatsCard(weatherData: _weatherData),
              const MapCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData; // Make weatherData nullable
  const StatsCard({super.key, this.weatherData}); // Update constructor

  @override
  Widget build(BuildContext context) {
    final bool isLoading = weatherData == null;

    // Helper to safely get data or return null if loading
    T? getData<T>(String key, [T? defaultValue]) {
      if (isLoading || weatherData![key] == null) return defaultValue;
      return weatherData![key] as T;
    }

    // Helper for conditional values
    dynamic getValue(
        dynamic loadingValue, dynamic Function() loadedValueCallback) {
      return isLoading ? loadingValue : loadedValueCallback();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stat(
            icon: Icons.thermostat,
            label: "Temp.",
            value: getValue(null, () => "${weatherData!['temperature']}°C"),
            color: getValue(
                Colors.grey,
                () => weatherData!['temperature'] > 35
                    ? Colors.red
                    : Colors.blue),
          ),
          Stat(
            icon: Icons.water_drop,
            label: "Humidity",
            value: getValue(
                null, () => "${weatherData!['humidity']?.toStringAsFixed(2)}%"),
            color: getValue(
                Colors.grey,
                () => weatherData!['humidity'] >= 80
                    ? Colors.red
                    : weatherData!['humidity'] <= 40
                        ? Colors.black
                        : Colors.blue),
          ),
          Stat(
            icon: getValue(
                Icons.cloud_outlined,
                () => weatherData!['rainSensor'] == 1
                    ? Icons.cloudy_snowing
                    : Icons.cloud),
            label: "Rain",
            value: getValue(null,
                () => weatherData!['rainSensor'] == 1 ? "Rain" : "No Rain"),
            color: getValue(
                Colors.grey,
                () => weatherData!['rainSensor'] == 1
                    ? Colors.blue
                    : Colors.black),
          ),
          Stat(
            icon: Icons.waves,
            label: "Water Lvl.",
            value: getValue(
                null,
                () =>
                    "${((weatherData!['waterLevel'] ?? 0) * 100).toStringAsFixed(2)}%"),
            color: getValue(
                Colors.grey,
                () => weatherData!['waterLevel'] > 0
                    ? Colors.blueAccent
                    : Colors.black),
          ),
        ],
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value; // Make value nullable
  final Color color;

  const Stat({
    super.key,
    required this.icon,
    required this.label,
    this.value, // Update constructor: value is now optional
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.175,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
        ],
      ),
      padding: const EdgeInsets.all(
          16), // Consider reducing padding if content is small
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center items horizontally
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          if (value != null)
            Text(
              value!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            SizedBox(
              // Constrain the size of the progress indicator
              height: 14, // Approximate height of the text
              width: 14, // Approximate width of the text
              child: CircularProgressIndicator(
                strokeWidth: 2.0, // Make it a bit thinner
                valueColor: AlwaysStoppedAnimation<Color>(
                    color), // Use the stat's color
              ),
            ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600]), // Slightly increased label size
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
    _currentPosition = const LatLng(10.858355, 122.737857);
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
    _mapController.move(
        LatLng(_currentPosition.latitude, _currentPosition.longitude),
        currentZoom + 0.5);
  }

  void _zoomOut() {
    double currentZoom = _mapController.camera.zoom;
    _mapController.move(
        LatLng(_currentPosition.latitude, _currentPosition.longitude),
        currentZoom - 0.5);
  }

  void _centerOnMarker() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
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
                    IgnorePointer(
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentPosition,
                          initialRotation: 50,
                          initialZoom: 14.7,
                          maxZoom: 20.5,
                          minZoom: 11.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile-{s}.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              // Marker(
                              //   point: LatLng(_currentPosition.latitude,
                              //       _currentPosition.longitude),
                              //   width: 60,
                              //   height: 60,
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: const [
                              //       Icon(
                              //         Icons.location_pin,
                              //         color: Colors.red,
                              //         size: 40,
                              //       ),
                              //       Text(
                              //         "You",
                              //         style: TextStyle(
                              //             fontSize: 12,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Marker(
                                point: const LatLng(10.865162, 122.738167),
                                width: 60,
                                height: 60,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.sensors,
                                        color: Colors.red, size: 40),
                                    Text(
                                      "Farm 001",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Marker(
                                point: const LatLng(10.857623, 122.731182),
                                width: 60,
                                height: 60,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.sensors,
                                        color: Colors.red, size: 40),
                                    Text(
                                      "Farm 002",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Marker(
                                point: const LatLng(10.855813, 122.741552),
                                width: 60,
                                height: 60,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.sensors,
                                        color: Colors.red, size: 40),
                                    Text(
                                      "Farm 003",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
      ),
    );
  }
}
