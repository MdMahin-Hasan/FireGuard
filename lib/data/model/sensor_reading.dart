/// Live snapshot of a fire sensor device (e.g. an ESP32 node).
class SensorReading {
  final String deviceId;
  final bool flameDetected;
  final double smokePpm;
  final double temperatureC;
  final double humidityPercent;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;

  const SensorReading({
    required this.deviceId,
    required this.flameDetected,
    required this.smokePpm,
    required this.temperatureC,
    required this.humidityPercent,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  String get temperatureLabel => '${temperatureC.toStringAsFixed(1)}C';
  String get humidityLabel => '${humidityPercent.toStringAsFixed(0)}%';
  String get smokeLabel => '${smokePpm.toStringAsFixed(0)} ppm';
  String get flameLabel => flameDetected ? 'Detected' : 'None';

  /// Google Maps link built from the sensor's coordinates.
  String get googleMapsLink =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      deviceId: json['deviceId'] as String,
      flameDetected: json['flameDetected'] as bool,
      smokePpm: (json['smokeValue'] as num).toDouble(),
      temperatureC: (json['temperature'] as num).toDouble(),
      humidityPercent: (json['humidity'] as num).toDouble(),
      timestamp: DateTime.parse(json['createdAt'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}