import 'package:get/get.dart';

import '../../../core/storage/auth_storage.dart';
import '../../../data/model/membership_model.dart';
import 'team_memcontroller.dart';

class ProfileController extends GetxController {
  final TeamMembersRepository _teamRepo = TeamMembersRepository();

  var name = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;
  final isEnabled = false.obs;
  var deviceId = ''.obs;

  // Current user's membership on this device — role (owner/member) and
  // status (active/pending), sourced from GET /api/devices/{deviceId}/members.
  Rx<MemberRole?> role = Rx<MemberRole?>(null);
  Rx<MemberStatus?> memberStatus = Rx<MemberStatus?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;

    // Name/email come from the session saved at login — there's no
    // dedicated "get profile" endpoint in the API.
    name.value = await AuthStorage.getName() ?? '';
    email.value = await AuthStorage.getEmail() ?? '';

    // Fall back to the shared mock device until a real device-linking
    // API exists (see HomeController/AlertController's 'esp32-01').
    deviceId.value = await AuthStorage.getDeviceId() ?? 'esp32-01';

    await _fetchMembership();

    isLoading.value = false;
  }

  Future<void> _fetchMembership() async {
    try {
      final userId = await AuthStorage.getUserId();
      final members = await _teamRepo.fetchFor(deviceId.value);

      DeviceMember? self;
      for (final m in members) {
        if (m.user.id == userId) {
          self = m;
          break;
        }
      }

      role.value = self?.role;
      memberStatus.value = self?.status;
    } catch (_) {
      // Non-fatal — profile still shows name/email without a role badge.
      role.value = null;
      memberStatus.value = null;
    }
  }
}