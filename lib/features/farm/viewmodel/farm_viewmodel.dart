import 'package:flutter/material.dart';
import '../model/farm_model.dart';

class FarmViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<FarmModel> farms = [];

  FarmViewModel() {
    fetchFarms();
  }

  Future<void> fetchFarms() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulated fetch
    farms = [
      FarmModel(name: 'Farm A', location: 'Dumangas'),
      FarmModel(name: 'Farm B', location: 'Iloilo City'),
    ];
    isLoading = false;
    notifyListeners();
  }
}
