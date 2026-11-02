import 'package:flutter/foundation.dart';

class LoggerHelper {
  LoggerHelper._();

  static final LoggerHelper instance =
  LoggerHelper._();

  void info(String message) {
    debugPrint("ℹ️ INFO : $message");
  }

  void success(String message) {
    debugPrint("✅ SUCCESS : $message");
  }

  void warning(String message) {
    debugPrint("⚠️ WARNING : $message");
  }

  void error({
    required Object error,
    StackTrace? stackTrace,
  }) {
    debugPrint("❌ ERROR : $error");

    if (stackTrace != null) {
      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }
}