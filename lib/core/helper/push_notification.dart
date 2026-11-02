import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationHelper {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// Register the current device's FCM token
  /// against all FireGuard devices belonging to the user.
  static Future<void> registerToken(
      List<String> deviceIds,
      ) async {
    if (deviceIds.isEmpty) {
      print('FCM: No device IDs found.');
      return;
    }

    try {
      // Ask notification permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print(
        'FCM permission: ${settings.authorizationStatus}',
      );

      // Get current FCM token
      final token = await _messaging.getToken();

      if (token == null || token.isEmpty) {
        print('FCM: Token is null/empty.');
        return;
      }

      print('FCM token obtained.');

      // Register token for every device
      for (final deviceId in deviceIds) {
        if (deviceId.trim().isEmpty) continue;

        await _firestore
            .collection('device_tokens')
            .doc(deviceId)
            .set(
          {
            'tokens': FieldValue.arrayUnion([token]),
          },
          SetOptions(merge: true),
        );

        print(
          'FCM: Token registered for $deviceId',
        );
      }
    } catch (e) {
      print(
        'FCM token registration failed: $e',
      );
    }
  }

  /// Keep Firestore updated if Firebase changes the token.
  static void listenForTokenRefresh(
      List<String> deviceIds,
      ) {
    _messaging.onTokenRefresh.listen(
          (newToken) async {
        print('FCM token refreshed.');

        for (final deviceId in deviceIds) {
          if (deviceId.trim().isEmpty) continue;

          try {
            await _firestore
                .collection('device_tokens')
                .doc(deviceId)
                .set(
              {
                'tokens': FieldValue.arrayUnion([newToken]),
              },
              SetOptions(merge: true),
            );

            print(
              'FCM: Refreshed token registered for $deviceId',
            );
          } catch (e) {
            print(
              'FCM refresh registration failed: $e',
            );
          }
        }
      },
    );
  }
}