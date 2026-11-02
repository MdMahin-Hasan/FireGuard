import 'sensor_reading.dart';

/// The lifecycle state of a fire alert, from first detection through
/// to close-out. `falseAlarm` is a terminal branch off `pending`;
/// `verified` -> `notified` -> `resolved` is the normal fire path.
enum FireAlertOutcome {
  pending,
  verified,
  falseAlarm,
  notified,
  resolved,
}

extension FireAlertOutcomeX on FireAlertOutcome {
  bool get isFire =>
      this == FireAlertOutcome.verified ||
          this == FireAlertOutcome.notified ;

  String title({String? falseAlarmReason}) {
    switch (this) {
      case FireAlertOutcome.verified:
        return 'Fire confirmed';
      case FireAlertOutcome.falseAlarm:
        return falseAlarmReason == null
            ? 'False alarm'
            : 'False alarm - $falseAlarmReason';
      case FireAlertOutcome.pending:
        return 'Awaiting verification';
      case FireAlertOutcome.notified:
        return 'Fire service notified';
      case FireAlertOutcome.resolved:
        return 'Resolved';
    }
  }
}

/// A single alert event raised by the ML model from a sensor reading.
class FireAlert {
  final String id;
  final String deviceId;
  final FireAlertOutcome status;
  final String? falseAlarmReason;
  final DateTime timestamp;
  final double mlConfidence;
  final SensorReading reading;
  final int otherVerifiersNotified;
  final String? verifiedBy;

  const FireAlert({
    required this.id,
    required this.deviceId,
    required this.status,
    required this.timestamp,
    required this.mlConfidence,
    required this.reading,
    this.falseAlarmReason,
    this.otherVerifiersNotified = 0,
    this.verifiedBy,
  });

  String get confidenceLabel => '${(mlConfidence * 100).round()}%';

  /// Public so callers merging *partial* alert payloads (e.g. the
  /// dashboard-verify / resolve responses, which don't include the full
  /// alert shape) can map the raw `status` string without re-parsing a
  /// whole [FireAlert].
  static FireAlertOutcome outcomeFromApiStatus(String status) {
    switch (status) {
      case 'verified_fire':
        return FireAlertOutcome.verified;
      case 'false_alarm':
        return FireAlertOutcome.falseAlarm;
      case 'notified':
        return FireAlertOutcome.notified;
      case 'resolved':
        return FireAlertOutcome.resolved;
      case 'pending_verification':
      default:
        return FireAlertOutcome.pending;
    }
  }

  /// Builds a [FireAlert] from the JSON shape returned by the alerts API
  /// (GET /api/alerts, GET /api/alerts/{id}) and by the `alert:*` socket
  /// events, which share the same populated-alert shape.
  ///
  /// `reading` is expected to be populated by the backend, but some
  /// historical/legacy alerts may have a null or missing reading (e.g. the
  /// referenced sensor reading was deleted, or population failed) - fall
  /// back to a zeroed-out reading rather than throwing and dropping the
  /// whole list.
  factory FireAlert.fromJson(Map<String, dynamic> json) {
    final rawReading = json['reading'] as Map<String, dynamic>?;
    final verifiedBy = json['verifiedBy'] as Map<String, dynamic>?;

    return FireAlert(
      id: json['_id'] as String,
      deviceId: rawReading?['deviceId'] as String? ?? 'unknown',
      status: outcomeFromApiStatus(json['status'] as String),
      timestamp: DateTime.parse(json['createdAt'] as String).toLocal(),
      mlConfidence: (json['mlConfidence'] as num?)?.toDouble() ?? 0,
      reading: rawReading != null
          ? SensorReading.fromJson(rawReading)
          : SensorReading(
        deviceId: 'unknown',
        flameDetected: false,
        smokePpm: 0,
        temperatureC: 0,
        humidityPercent: 0,
        timestamp: DateTime.parse(json['createdAt'] as String).toLocal(),
      ),
      verifiedBy: verifiedBy?['name'] as String?,
    );
  }
}