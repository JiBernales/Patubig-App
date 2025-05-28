import 'package:firebase_database/firebase_database.dart';
import '../../features/farm/model/weather_model.dart'; // Make sure this import path is correct

class FirebaseService {
  Stream<WeatherModel?> getWeatherDataStream(String farmId) {
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("farms/$farmId/readings");

    return databaseRef
        .orderByKey()
        .limitToLast(1)
        .onValue
        .map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> readings =
            Map<String, dynamic>.from(event.snapshot.value as Map);

        final latestReading = readings.values.first as Map;
        return WeatherModel.fromMap(Map<String, dynamic>.from(latestReading));
      }
      return null;
    });
  }

  // New method to get the irrigation queue
  Stream<Map<String, dynamic>?> getIrrigationQueueStream() {
    DatabaseReference queueRef =
        FirebaseDatabase.instance.ref("irrigationQueue");

    return queueRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // The queue is a map where keys are farmIds and values are farm data
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }

  // Optional: Get the irrigation queue status
  Stream<Map<String, dynamic>?> getIrrigationQueueStatusStream() {
    DatabaseReference statusRef =
        FirebaseDatabase.instance.ref("irrigationQueueStatus");

    return statusRef.onValue.map((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return null;
    });
  }

  /// Stream the current virtual-reservoir level (null until it exists).
  Stream<double?> getVirtualReservoirStream() {
    final ref = FirebaseDatabase.instance.ref('virtualReservoir');

    return ref.onValue.map((event) {
      if (event.snapshot.value == null) return null;

      final raw = event.snapshot.value!;
      return raw is num ? raw.toDouble() : double.tryParse(raw.toString());
    });
  }

  /// Fetch the value once (useful in an initState or a manual refresh).
  Future<double?> fetchVirtualReservoirOnce() async {
    final ref = FirebaseDatabase.instance.ref('virtualReservoir');

    final snap = await ref.get();
    if (!snap.exists) return null;

    final raw = snap.value!;
    return raw is num ? raw.toDouble() : double.tryParse(raw.toString());
  }
}
