import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/weather_utils.dart';
import '../../viewmodel/weather_calendar_viewmodel.dart';
import '../widgets/weather_day_widgets.dart';

class WeatherForecastCard extends StatefulWidget {
  const WeatherForecastCard({super.key});

  @override
  _WeatherForecastCardState createState() => _WeatherForecastCardState();
}

class _WeatherForecastCardState extends State<WeatherForecastCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCalendarViewModel>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE').format(DateTime.now());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 12),
            child: Text(
              "Weather Forecast",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.agriculture_rounded,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FarmID00111",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Rice Field - Palay",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Consumer<WeatherCalendarViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.weatherForecast.isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTodayWeather(today, viewModel),
                          ),
                          if (viewModel.weatherForecast.forecast != null && 
                              viewModel.weatherForecast.forecast!.length > 15) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  WeatherDay(
                                    day: DateFormat('EEE').format(viewModel.weatherForecast.forecast![0].date!),
                                    label: formatWeatherDescription(viewModel.weatherForecast.forecast![0].weatherMain),
                                    icon: getWeatherIcon(viewModel.weatherForecast.forecast![0].weatherIcon),
                                    isCompact: true,
                                  ),
                                  WeatherDay(
                                    day: DateFormat('EEE').format(viewModel.weatherForecast.forecast![7].date!),
                                    label: formatWeatherDescription(viewModel.weatherForecast.forecast![7].weatherMain),
                                    icon: getWeatherIcon(viewModel.weatherForecast.forecast![7].weatherIcon),
                                    isCompact: true,
                                  ),
                                  WeatherDay(
                                    day: DateFormat('EEE').format(viewModel.weatherForecast.forecast![15].date!),
                                    label: formatWeatherDescription(viewModel.weatherForecast.forecast![15].weatherMain),
                                    icon: getWeatherIcon(viewModel.weatherForecast.forecast![15].weatherIcon),
                                    isCompact: true,
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayWeather(String today, WeatherCalendarViewModel viewModel) {
    return Column(
      children: [
        Text(
          today,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            getWeatherIcon(viewModel.weatherForecast.currentWeather?.weatherIcon),
            size: 60,
            color: getWeatherColor(viewModel.weatherForecast.currentWeather?.weatherMain),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          formatWeatherDescription(viewModel.weatherForecast.currentWeather?.weatherMain),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (viewModel.weatherForecast.currentWeather?.temperature?.celsius != null) ...[
          const SizedBox(height: 4),
          Text(
            "${viewModel.weatherForecast.currentWeather!.temperature!.celsius!.round()}°C",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
}