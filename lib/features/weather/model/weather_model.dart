class WeatherModel {
  final String? date;
  final double? temperature;

  WeatherModel({this.date, this.temperature});

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      date: map['date'] as String?,
      temperature: (map['temperature'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'temperature': temperature,
    };
  }
}