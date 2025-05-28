import 'package:flutter/material.dart';
import 'stat_widget.dart'; // Assuming StatWidget is in 'stat_widget.dart'

class StatsCard extends StatefulWidget {
  final Map<String, dynamic>? weatherData;
  const StatsCard({super.key, this.weatherData});

  @override
  _StatsCardState createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> with TickerProviderStateMixin {
  late AnimationController _containerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Added for growth stage dropdown
  String _selectedGrowthStage = 'Tillering'; // Default growth stage
  final List<String> _growthStages = [
    'Germination',
    'Seedling',
    'Tillering',
    'Panicle Initiation',
    'Flowering',
    'Grain Filling',
    'Pre-Harvest Drainage', // Renamed from "Pre-Harvest" for clarity
  ];

  @override
  void initState() {
    super.initState();
    _containerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = widget.weatherData == null;

    // Helper to safely get data or return null if loading
    T? getData<T>(String key, [T? defaultValue]) {
      if (isLoading || widget.weatherData![key] == null) return defaultValue;
      return widget.weatherData![key] as T;
    }

    // Helper for conditional values
    dynamic getValue(
        dynamic loadingValue, dynamic Function() loadedValueCallback) {
      return isLoading ? loadingValue : loadedValueCallback();
    }

    return AnimatedBuilder(
      animation: _containerController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.blue.shade50.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.blue.shade100.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: -5,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(isLoading),
                  const SizedBox(height: 16), // Smaller gap after header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Pumili ng growth stage",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  // Growth Stage Dropdown
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade50,
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGrowthStage,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        items: _growthStages.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(value),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedGrowthStage = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Gap before sensor data
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildStatWithDelay(
                              icon: Icons.thermostat,
                              label: "Temperature",
                              value: getValue(
                                  null,
                                  () =>
                                      "${widget.weatherData!['temperature']?.toStringAsFixed(1)}°C"),
                              color: getValue(
                                  Colors.grey,
                                  () => _getTemperatureColor(
                                      widget.weatherData!['temperature'],
                                      _selectedGrowthStage)),
                              delay: 0,
                            ),
                            const SizedBox(height: 24),
                            _buildStatWithDelay(
                              icon: getValue(
                                  Icons.cloud_outlined,
                                  () => widget.weatherData!['rainSensor'] == 1
                                      ? Icons.cloudy_snowing
                                      : Icons.wb_sunny),
                              label: "Weather",
                              value: getValue(
                                  null,
                                  () => widget.weatherData!['rainSensor'] == 1
                                      ? "Rainy"
                                      : "Clear"),
                              color: getValue(
                                  Colors.grey,
                                  () => widget.weatherData!['rainSensor'] == 1
                                      ? Colors.blue.shade600
                                      : Colors.orange.shade600),
                              delay: 200,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildStatWithDelay(
                              icon: Icons.water_drop,
                              label: "Humidity",
                              value: getValue(
                                  null,
                                  () =>
                                      "${widget.weatherData!['humidity']?.toStringAsFixed(1)}%"),
                              color: getValue(
                                  Colors.grey,
                                  () => _getHumidityColor(
                                      widget.weatherData!['humidity'],
                                      _selectedGrowthStage)),
                              delay: 100,
                            ),
                            const SizedBox(height: 24),
                            _buildStatWithDelay(
                              icon: Icons.waves,
                              label: "Water Level",
                              // Water level value might be more descriptive than just a percentage,
                              // if 100% means full capacity, and 0% means empty.
                              // Let's assume waterLevel is in cm for now, as discussed earlier.
                              value: getValue(
                                  null,
                                  () => widget.weatherData!['waterLevel'] !=
                                          null
                                      ? "${widget.weatherData!['waterLevel']?.toStringAsFixed(1)} %"
                                      : "N/A"),
                              color: getValue(
                                  Colors.grey,
                                  () => _getWaterLevelColor(
                                      widget.weatherData!['waterLevel'],
                                      _selectedGrowthStage)),
                              delay: 300,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isLoading) ...[
                    const SizedBox(height: 24),
                    _buildStatusIndicator(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLoading ? Icons.refresh : Icons.sensors,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isLoading ? 'Nagakarga sang mga Sensor...' : 'Live nga Datos sang Sensor',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatWithDelay({
    required IconData icon,
    required String label,
    String? value,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.elasticOut,
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: Stat(
            icon: icon,
            label: label,
            value: value,
            color: color,
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator() {
    final temp = widget.weatherData!['temperature'] ?? 0.0;
    final humidity = widget.weatherData!['humidity'] ?? 0.0;
    final waterLevel = widget.weatherData!['waterLevel'] ??
        0.0; // Assuming water level is in cm

    String status = "Optimal";
    Color statusColor = Colors.green;
    IconData statusIcon = Icons.check_circle;

    // Define optimal, attention, and critical ranges based on growth stage
    double optimalTempMin, optimalTempMax;
    double criticalTempMin, criticalTempMax;
    double optimalHumidityMin, optimalHumidityMax;
    double criticalHumidityMin, criticalHumidityMax;
    double optimalWaterMin, optimalWaterMax;
    double criticalWaterMin, criticalWaterMax;

    // Default general critical/attention ranges (as a fallback or for general humidity/temp)
    criticalTempMin = 15.0; // Below this is critical
    criticalTempMax = 37.0; // Above this is critical
    optimalTempMin = 20.0;
    optimalTempMax = 35.0;

    criticalHumidityMin = 40.0; // Below this is critical
    criticalHumidityMax = 85.0; // Above this is critical
    optimalHumidityMin = 55.0;
    optimalHumidityMax = 80.0;

    // Water level ranges are highly dependent on growth stage
    switch (_selectedGrowthStage) {
      case 'Germination':
        // Soil should be moist, but not heavily flooded. Water level can be 0 or 1-2cm.
        optimalWaterMin = 0.0;
        optimalWaterMax = 2.0; // Just moist soil or very shallow water
        criticalWaterMin =
            -5.0; // Assuming negative implies dry soil, adjust if sensor provides different dry value
        criticalWaterMax = 10.0; // Too deep for germination
        break;
      case 'Seedling':
        // Shallow water to encourage root establishment.
        optimalWaterMin = 2.0;
        optimalWaterMax = 5.0;
        criticalWaterMin = 0.0;
        criticalWaterMax = 15.0;
        break;
      case 'Tillering':
        // Maintain shallow to moderate water depth to promote tillering.
        optimalWaterMin = 5.0;
        optimalWaterMax = 10.0;
        criticalWaterMin = 2.0;
        criticalWaterMax = 20.0;
        break;
      case 'Panicle Initiation':
        // Consistent water depth is crucial.
        optimalWaterMin = 5.0;
        optimalWaterMax = 15.0;
        criticalWaterMin = 2.0;
        criticalWaterMax = 25.0;
        break;
      case 'Flowering':
        // Critical period for water, maintain moderate depth. Avoid stress.
        optimalWaterMin = 5.0;
        optimalWaterMax = 15.0;
        criticalWaterMin = 2.0;
        criticalWaterMax = 25.0;
        // High temp/humidity during flowering can cause sterility
        if (temp > 35 && humidity > 80) {
          status = "Critical";
          statusColor = Colors.red;
          statusIcon = Icons.error;
          return _buildStatusContainer(
              status, statusColor, statusIcon); // Exit early if critical
        }
        break;
      case 'Grain Filling':
        // Keep water consistent, but can be slightly lower than flowering.
        optimalWaterMin = 5.0;
        optimalWaterMax = 10.0;
        criticalWaterMin = 2.0;
        criticalWaterMax = 20.0;
        break;
      case 'Pre-Harvest Drainage':
        // Field should be drained. Water level should be low or zero.
        optimalWaterMin = -5.0; // Below soil surface or completely drained
        optimalWaterMax = 2.0;
        criticalWaterMin = 3.0; // Water still too high for drainage
        criticalWaterMax = 50.0; // Any high water is critical
        break;
      default: // Fallback to general optimal if stage not recognized
        optimalWaterMin = 5.0;
        optimalWaterMax = 10.0;
        criticalWaterMin = 0.0;
        criticalWaterMax = 20.0;
        break;
    }

    // --- Apply the refined criteria ---

    // Critical conditions
    if (temp < criticalTempMin ||
        temp > criticalTempMax ||
        humidity < criticalHumidityMin ||
        humidity > criticalHumidityMax ||
        // Water level critical conditions (note the logical flow: critical if outside range)
        (waterLevel < optimalWaterMin &&
            waterLevel < criticalWaterMin) || // Below critical low
        (waterLevel > optimalWaterMax && waterLevel > criticalWaterMax)) {
      // Above critical high
      status = "Critical";
      statusColor = Colors.red;
      statusIcon = Icons.error;
    }
    // Attention Needed conditions
    else if ((temp < optimalTempMin || temp > optimalTempMax) ||
        (humidity < optimalHumidityMin || humidity > optimalHumidityMax) ||
        (waterLevel < optimalWaterMin || waterLevel > optimalWaterMax)) {
      // Water level outside optimal, but not yet critical
      status = "Attention Needed";
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
    }
    // Optimal conditions
    else {
      status = "Optimal";
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    }

    // Special condition for water level when drained
    if (_selectedGrowthStage == 'Pre-Harvest Drainage' && waterLevel >= 3.0) {
      status = "Attention Needed";
      statusColor = Colors.orange;
      statusIcon = Icons.warning;
      if (waterLevel >= 10.0) {
        // If water is still significantly high
        status = "Critical";
        statusColor = Colors.red;
        statusIcon = Icons.error;
      }
    }

    return _buildStatusContainer(status, statusColor, statusIcon);
  }

  // Helper widget for the status display
  Widget _buildStatusContainer(
      String status, Color statusColor, IconData statusIcon) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Farm Status: $status',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Helper functions for color indication of individual stats ---
  Color _getTemperatureColor(double? temperature, String growthStage) {
    if (temperature == null) return Colors.grey;

    double optimalMin, optimalMax;
    double criticalMin, criticalMax;

    // General temperature guidelines for all stages
    criticalMin = 15.0;
    criticalMax = 37.0;
    optimalMin = 20.0;
    optimalMax = 35.0;

    // Specific adjustments for certain stages if needed
    if (growthStage == 'Flowering' && temperature > 35) {
      return Colors.red.shade600; // Even 35+ during flowering is critical
    }
    if (growthStage == 'Germination' && temperature < 20) {
      return Colors.orange.shade600; // Slows germination
    }

    if (temperature < criticalMin || temperature > criticalMax) {
      return Colors.red.shade600;
    } else if (temperature < optimalMin || temperature > optimalMax) {
      return Colors.orange.shade600;
    }
    return Colors.blue.shade600; // Optimal (or near optimal)
  }

  Color _getHumidityColor(double? humidity, String growthStage) {
    if (humidity == null) return Colors.grey;

    double optimalMin = 55.0;
    double optimalMax = 80.0;
    double criticalMin = 40.0;
    double criticalMax = 85.0;

    // High humidity combined with high temperature during flowering can be critical
    if (growthStage == 'Flowering' &&
        humidity > 80 &&
        (widget.weatherData?['temperature'] ?? 0.0) > 35) {
      return Colors.red.shade600;
    }

    if (humidity < criticalMin || humidity > criticalMax) {
      return Colors.red.shade600;
    } else if (humidity < optimalMin || humidity > optimalMax) {
      return Colors.orange.shade600;
    }
    return Colors.blue.shade600;
  }

  Color _getWaterLevelColor(double? waterLevel, String growthStage) {
    if (waterLevel == null) return Colors.grey;

    double optimalMin, optimalMax;
    double attentionMin, attentionMax; // Define thresholds for orange

    switch (growthStage) {
      case 'Germination':
        optimalMin = 0.0;
        optimalMax = 2.0;
        attentionMin = -1.0; // Slightly dry
        attentionMax = 5.0; // Slightly wet/deep
        break;
      case 'Seedling':
        optimalMin = 2.0;
        optimalMax = 5.0;
        attentionMin = 0.0;
        attentionMax = 10.0;
        break;
      case 'Tillering':
        optimalMin = 5.0;
        optimalMax = 10.0;
        attentionMin = 2.0;
        attentionMax = 15.0;
        break;
      case 'Panicle Initiation':
      case 'Flowering':
      case 'Grain Filling':
        optimalMin = 5.0;
        optimalMax = 15.0;
        attentionMin = 2.0;
        attentionMax = 20.0;
        break;
      case 'Pre-Harvest Drainage':
        optimalMin = -5.0; // Drained
        optimalMax = 2.0;
        attentionMin = 2.0; // Not fully drained but low
        attentionMax = 5.0; // Still too wet
        // If waterLevel > 5.0 for pre-harvest, it's already critical
        if (waterLevel > 5.0) return Colors.red.shade600;
        break;
      default: // Fallback general or initial
        optimalMin = 5.0;
        optimalMax = 10.0;
        attentionMin = 2.0;
        attentionMax = 15.0;
        break;
    }

    if (waterLevel < optimalMin || waterLevel > optimalMax) {
      if ((waterLevel < attentionMin && attentionMin != optimalMin) ||
          (waterLevel > attentionMax && attentionMax != optimalMax)) {
        return Colors.red.shade600; // Critical outside attention range
      }
      return Colors.orange.shade600; // Attention needed
    }
    return Colors.blue.shade600; // Optimal
  }
}
