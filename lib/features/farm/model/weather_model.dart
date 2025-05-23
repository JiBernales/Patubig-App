class WeatherModel {
  final double? temperature;
  final double? humidity;
  final int? rainSensor;
  final double? waterLevel;

  WeatherModel({
    this.temperature,
    this.humidity,
    this.rainSensor,
    this.waterLevel,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      temperature: map['temperature']?.toDouble(),
      humidity: map['humidity']?.toDouble(),
      rainSensor: map['rainSensor']?.toInt(),
      waterLevel: map['waterLevel']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'rainSensor': rainSensor,
      'waterLevel': waterLevel,
    };
  }
}