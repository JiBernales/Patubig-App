import 'package:firebase_database/firebase_database.dart';
import '../../features/farm/model/weather_model.dart';

class FirebaseService {
  static final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("farm1");

  static Stream<WeatherModel?> getWeatherDataStream() {
    return _databaseRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return WeatherModel.fromMap(data);
      }
      return null;
    });
  }
}