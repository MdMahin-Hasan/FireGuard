import '../../core/constant/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/auth_storage.dart';

class InvitationService {
  InvitationService._();
  static final InvitationService instance = InvitationService._();

  final ApiClient _client = ApiClient();

  /// Invites [email] to the logged-in owner's device team. Throws
  /// [ApiException] on failure (403 not owner, 409 team full, etc.).
  Future<void> sendInvite(String email) async {
    final deviceId = await AuthStorage.getDeviceId();
    if (deviceId == null) throw ApiException(statusCode: 0, message: 'Please log in again.');

    await _client.post(
      ApiConstants.inviteMember(deviceId),
      {'email': email},
      authRequired: true,
    );
  }
}