// features/farm/viewmodel/weather_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../model/weather_model.dart';
import '../model/location_model.dart';
import '../../../core/services/firebase_farm_service.dart';
import '../../../core/services/location_service.dart';

class FarmWeatherViewModel extends ChangeNotifier {
  WeatherModel? _weatherData;
  LocationModel? _currentLocation;
  late MapController _mapController;

  WeatherModel? get weatherData => _weatherData;
  LocationModel? get currentLocation => _currentLocation;
  MapController get mapController => _mapController;

  FarmWeatherViewModel() {
    _mapController = MapController();
    _currentLocation = LocationModel(latitude: 10.858355, longitude: 122.737857);
    _initializeData();
  }

  void _initializeData() {
    _fetchWeatherData();
    _loadLocation();
  }

  void _fetchWeatherData() {
    final firebaseService = FirebaseService();
    firebaseService.getWeatherDataStream().listen((WeatherModel? data) {
      _weatherData = data;
      notifyListeners();
    });
  }

  Future<void> _loadLocation() async {
    try {
      LocationModel location = await LocationService.getCurrentLocation();
      _currentLocation = location;
      notifyListeners();
    } catch (e) {
      print('Error loading location: $e');
    }
  }

  void zoomIn() {
    if (_currentLocation != null) {
      double currentZoom = _mapController.camera.zoom;
      _mapController.move(_currentLocation!.latLng, currentZoom + 0.5);
    }
  }

  void zoomOut() {
    if (_currentLocation != null) {
      double currentZoom = _mapController.camera.zoom;
      _mapController.move(_currentLocation!.latLng, currentZoom - 0.5);
    }
  }

  void centerOnMarker() {}
}