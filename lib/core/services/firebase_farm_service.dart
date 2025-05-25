import 'package:firebase_database/firebase_database.dart';
import '../../features/farm/model/weather_model.dart';

class FirebaseService {
  DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("farms/farm_003/readings");

  Stream<WeatherModel?> getWeatherDataStream() {
    return _databaseRef
        .orderByKey()
        .limitToLast(1)
        .onValue
        .map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> readings =
        Map<String, dynamic>.from(event.snapshot.value as Map);

        // Get the first (latest) reading
        final latestReading = readings.values.first as Map;
        return WeatherModel.fromMap(Map<String, dynamic>.from(latestReading));
      }
      return null;
    });
  }

}