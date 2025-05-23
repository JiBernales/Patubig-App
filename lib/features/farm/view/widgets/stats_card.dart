import 'package:flutter/material.dart';
import 'stat_widget.dart';

class StatsCard extends StatelessWidget {
  final Map<String, dynamic>? weatherData;
  const StatsCard({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = weatherData == null;

    // Helper to safely get data or return null if loading
    T? getData<T>(String key, [T? defaultValue]) {
      if (isLoading || weatherData![key] == null) return defaultValue;
      return weatherData![key] as T;
    }

    // Helper for conditional values
    dynamic getValue(dynamic loadingValue, dynamic loadedValueCallback()) {
        return isLoading ? loadingValue : loadedValueCallback();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Stat(
                    icon: Icons.thermostat,
                    label: "Temp.",
                    value: getValue(null, () => "${weatherData!['temperature']}°C"),
                    color: getValue(Colors.grey, () => weatherData!['temperature'] > 35 ? Colors.red : Colors.blue),
                  ),
                ],
              ),
              Row(
                children: [
                  Stat(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: getValue(null, () => "${weatherData!['humidity']?.toStringAsFixed(2)}%"),
                    color: getValue(Colors.grey, () => weatherData!['humidity'] >= 80
                        ? Colors.red
                        : weatherData!['humidity'] <= 40
                        ? Colors.black
                        : Colors.blue),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Stat(
                    icon: getValue(Icons.cloud_outlined, () => weatherData!['rainSensor'] == 1 ? Icons.cloudy_snowing : Icons.cloud),
                    label: "Rain",
                    value: getValue(null, () => weatherData!['rainSensor'] == 1 ? "Rain" : "No Rain"),
                    color: getValue(Colors.grey, () => weatherData!['rainSensor'] == 1 ? Colors.blue : Colors.black),
                  ),
                ],
              ),
              Row(
                children: [
                  Stat(
                    icon: Icons.waves,
                    label: "Water Lvl.",
                    value: getValue(null, () => weatherData!['waterLevel'] > 0 ? "${((weatherData!['waterLevel'] ?? 0)).toStringAsFixed(2)}%": "0%"),
                    color: getValue(Colors.grey, () => weatherData!['waterLevel'] > 0 ? Colors.blueAccent : Colors.black),
                  ),
                ],
              )
            ],
          ),
        ],
      )
    );
  }
}