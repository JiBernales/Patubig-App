import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weather_viewmodel.dart';

class WeatherCalendarScreen extends StatelessWidget {
  const WeatherCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Calendar'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: viewModel.weatherData.length,
              itemBuilder: (context, index) {
                final weather = viewModel.weatherData[index];
                return ListTile(
                  title: Text(weather.date ?? 'Unknown Date'),
                  subtitle: Text('Temp: ${weather.temperature}°C'),
                );
              },
            ),
    );
  }
}
