import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'app/app.dart';
import 'app/app_initializer.dart';
import 'core/constant/deep_link_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      await AppInitializer.instance.initialize();

      await Get.putAsync(
            () => DeepLinkService().init(),
      );

      runApp(const FireAlert());
    },
    AppInitializer.instance.onUnhandledError,
  );
}