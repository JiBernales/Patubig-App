import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_calendar_viewmodel.dart';
import 'widgets/weather_forecast_card.dart';
import 'widgets/planting_date_card.dart';

class WeatherCalendarScreen extends StatelessWidget {
  const WeatherCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherCalendarViewModel(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              WeatherForecastCard(),
              SizedBox(height: 16),
              PlantingDateCard(),
            ],
          ),
        ),
      ),
    );
  }
}