// features/farm/viewmodel/weather_viewmodel.dart
import 'dart:async'; // Import async for StreamSubscription
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:patubig_app/core/services/firebase_farm_service.dart'; // Corrected import
import '../model/weather_model.dart';
import '../model/location_model.dart';
import '../../../core/services/location_service.dart';

class FarmWeatherViewModel extends ChangeNotifier {
  WeatherModel? _weatherData;
  LocationModel? _currentLocation;
  late MapController _mapController;
  final FirebaseService _firebaseService = FirebaseService(); // Instance of FirebaseService
  StreamSubscription? _weatherSubscription; // To manage the stream listener

  // Add farm selection state
  final List<String> _farmIds = ['farm_001', 'farm_002', 'farm_003'];
  String _selectedFarmId = 'farm_003'; // Default selection

  WeatherModel? get weatherData => _weatherData;
  LocationModel? get currentLocation => _currentLocation;
  MapController get mapController => _mapController;
  List<String> get farmIds => _farmIds;
  String get selectedFarmId => _selectedFarmId;

  FarmWeatherViewModel() {
    _mapController = MapController();
    _currentLocation = LocationModel(latitude: 10.858355, longitude: 122.737857);
    _initializeData();
  }

  void _initializeData() {
    _fetchWeatherData(_selectedFarmId); // Fetch for the default farm
    _loadLocation();
  }

  void _fetchWeatherData(String farmId) {
    // Cancel any existing subscription before creating a new one
    _weatherSubscription?.cancel();

    _weatherSubscription =
        _firebaseService.getWeatherDataStream(farmId).listen((WeatherModel? data) {
      _weatherData = data;
      notifyListeners(); // Notify listeners when new data arrives
    }, onError: (error) {
       print('Error fetching weather data: $error');
       _weatherData = null; // Clear data on error
       notifyListeners();
    });
  }

  // Method to change the selected farm
  void changeFarm(String newFarmId) {
    if (_farmIds.contains(newFarmId) && _selectedFarmId != newFarmId) {
      _selectedFarmId = newFarmId;
      _weatherData = null; // Clear old data while new data is fetching
      notifyListeners(); // Notify listeners about the farm change
      _fetchWeatherData(newFarmId); // Fetch data for the new farm
    }
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

  // Dispose the stream subscription when the ViewModel is disposed
  @override
  void dispose() {
    _weatherSubscription?.cancel();
    super.dispose();
  }
}