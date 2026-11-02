import '../../core/constant/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/auth_storage.dart';
import '../model/auth_result.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  // ============================================================
  // REGISTER OWNER
  // ============================================================

  Future<AuthResult> registerOwner({
    required String deviceId,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final data = await _client.post(
        ApiConstants.registerOwner,
        {
          'deviceId': deviceId,
          'name': name,
          'email': email,
          'password': password,
        },
      );

      await _saveSession(
        data,
        deviceId: deviceId,
      );

      // Registration normally has one device.
      return AuthResult.success(
        deviceIds: [deviceId],
      );
    } on ApiException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(
        'Registration failed. Please try again.',
      );
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _client.post(
        ApiConstants.login,
        {
          'email': email,
          'password': password,
        },
      );

      // Save normal authentication/session information.
      await _saveSession(data);

      // ----------------------------------------------------------
      // GET DEVICE IDS FROM MEMBERSHIPS
      // ----------------------------------------------------------
      //
      // Expected API structure:
      //
      // "memberships": [
      //   {
      //     "device": "esp32-01",
      //     "role": "owner"
      //   }
      // ]
      //
      // A user can have multiple devices.
      // ----------------------------------------------------------

      final memberships =
          data['memberships'] as List? ?? [];

      final deviceIds = memberships
          .map(
            (membership) {
          if (membership is Map) {
            return membership['device'] as String?;
          }

          return null;
        },
      )
          .whereType<String>()
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      return AuthResult.success(
        deviceIds: deviceIds,
      );
    } on ApiException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(
        'Login failed. Please try again.',
      );
    }
  }

  // ============================================================
  // ACCEPT INVITE
  // ============================================================

  Future<AuthResult> acceptInvite({
    required String token,
    required String name,
    required String password,
  }) async {
    try {
      final data = await _client.post(
        ApiConstants.acceptInvite,
        {
          'token': token,
          'name': name,
          'password': password,
        },
      );

      await _saveSession(data);

      // ----------------------------------------------------------
      // GET DEVICE IDS FROM MEMBERSHIPS
      // ----------------------------------------------------------

      final memberships =
          data['memberships'] as List? ?? [];

      final deviceIds = memberships
          .map(
            (membership) {
          if (membership is Map) {
            return membership['device'] as String?;
          }

          return null;
        },
      )
          .whereType<String>()
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      return AuthResult.success(
        deviceIds: deviceIds,
      );
    } on ApiException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(
        'Accepting invitation failed. Please try again.',
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    await AuthStorage.logout();
  }

  // ============================================================
  // SAVE SESSION
  // ============================================================

  Future<void> _saveSession(
      Map<String, dynamic> data, {
        String? deviceId,
      }) async {
    // ----------------------------------------------------------
    // The API returns the device inside memberships.
    //
    // Example:
    //
    // "memberships": [
    //   {
    //     "device": "esp32-01",
    //     "role": "owner"
    //   }
    // ]
    // ----------------------------------------------------------

    final memberships =
    data['memberships'] as List?;

    final membershipDeviceId =
    (memberships != null &&
        memberships.isNotEmpty &&
        memberships.first is Map)
        ? memberships.first['device'] as String?
        : null;

    // ----------------------------------------------------------
    // Save normal authentication/session information.
    // ----------------------------------------------------------

    await AuthStorage.saveSession(
      token: data['token'],
      userId: data['user']['id'],
      email: data['user']['email'],
      name: data['user']['name'],

      // Prefer device from API.
      // Fall back to deviceId supplied by caller.
      deviceId:
      membershipDeviceId ?? deviceId,
    );
  }
}