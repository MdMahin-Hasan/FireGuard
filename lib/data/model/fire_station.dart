import 'dart:math';

/// A nearby fire station that can be alerted via WhatsApp.
class FireStation {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final String phoneNumber; // international format, e.g. +8801XXXXXXXXX

  const FireStation({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
  });

  /// Google Maps link to this station's location.
  String get googleMapsLink =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  factory FireStation.fromJson(Map<String, dynamic> json) {
    return FireStation(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['whatsappNumber'] as String,
    );
  }

  /// Straight-line distance in km from [fromLat]/[fromLng] to this station,
  /// using the haversine formula.
  double distanceFromKm(double fromLat, double fromLng) {
    const earthRadiusKm = 6371.0;
    final dLat = _degToRad(latitude - fromLat);
    final dLng = _degToRad(longitude - fromLng);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(fromLat)) *
            cos(_degToRad(latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  String distanceLabelFrom(double fromLat, double fromLng) =>
      '${distanceFromKm(fromLat, fromLng).toStringAsFixed(1)} km away';

  double _degToRad(double deg) => deg * (pi / 180);
}