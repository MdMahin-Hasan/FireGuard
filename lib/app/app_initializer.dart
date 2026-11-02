import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/helper/logger_helper.dart';

class AppInitializer {
  AppInitializer._();

  static final AppInitializer instance = AppInitializer._();

  Future<void> initialize() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      _initializeFlutterError();

      await _initializeSystemUI();


      await _initializeDatabase();

      LoggerHelper.instance.success(
        "Application initialized successfully.",
      );
    } catch (error, stackTrace) {
      LoggerHelper.instance.error(
        error: error,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }


  void _initializeFlutterError() {
    FlutterError.onError = (FlutterErrorDetails details) {
      LoggerHelper.instance.error(
        error: details.exception,
        stackTrace: details.stack,
      );
    };
  }


  Future<void> _initializeSystemUI() async {
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );

    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }


 /* Future<void> _initializeStorage() async {

    await Get.putAsync(
          () => StorageService().init(),
    );

    Get.put(
      AuthService(),
    );

    debugPrint("Storage and Auth services initialized");
  }*/


  Future<void> _initializeDatabase() async {
    // Initialize database here later
    // Example:
    // await Hive.initFlutter();
  }


  void onUnhandledError(
      Object error,
      StackTrace stackTrace,
      ) {
    LoggerHelper.instance.error(
      error: error,
      stackTrace: stackTrace,
    );
  }
}