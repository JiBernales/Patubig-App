import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_calendar_viewmodel.dart';
import 'widgets/weather_forecast_card.dart';
import 'widgets/planting_date_card.dart';

class PlantingCalendarScreen extends StatelessWidget {
  const PlantingCalendarScreen({super.key});

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
              PlantingDateCard(),
            ],
          ),
        ),
      ),
    );
  }
}