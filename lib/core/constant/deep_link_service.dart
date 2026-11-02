import 'package:app_links/app_links.dart';
import 'package:firedetection_system/app/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();

  Future<DeepLinkService> init() async {
    // Cold start
    final Uri? initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      _handle(initialUri);
    }

    // Warm start
    _appLinks.uriLinkStream.listen(
          (Uri uri) {
        _handle(uri);
      },
      onError: (error) {
        debugPrint('Deep link error: $error');
      },
    );

    return this;
  }

  void _handle(Uri uri) {
    debugPrint('Deep link received: $uri');

    final token = uri.queryParameters['token'];

    if (uri.path.contains('/invite') && token != null) {
      Get.toNamed(
        AppRoutes.accept_invite,
        arguments: token,
      );
    }
  }
}