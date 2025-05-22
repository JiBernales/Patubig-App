// features/farm/view/weather_stats_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/farm_viewmodel.dart';
import 'widgets/stats_card.dart';
import 'widgets/map_card.dart';

class WeatherStatsScreen extends StatefulWidget {
  const WeatherStatsScreen({super.key});

  @override
  _WeatherStatsScreenState createState() => _WeatherStatsScreenState();
}

class _WeatherStatsScreenState extends State<WeatherStatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<FarmWeatherViewModel>(
                builder: (context, viewModel, child) {
                  return StatsCard(weatherData: viewModel.weatherData?.toMap());
                },
              ),
              const MapCard(),
            ],
          ),
        ),
      ),
    );
  }
}