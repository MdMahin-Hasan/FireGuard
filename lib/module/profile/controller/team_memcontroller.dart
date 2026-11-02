import 'package:flutter/foundation.dart';

import '../../../core/constant/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/model/membership_model.dart';

enum LoadStatus { loading, success, error }

class TeamMembersRepository {
  final ApiClient _client = ApiClient();

  Future<void> invite(String deviceId, String email) => _client.post(
    ApiConstants.inviteMember(deviceId),
    {'email': email},
    authRequired: true,
  );

  Future<void> remove(String deviceId, String userId) => _client.delete(
    ApiConstants.removeMember(deviceId, userId),
    authRequired: true,
  );

  Future<List<DeviceMember>> fetchFor(String deviceId) async {
    final data = await _client.get(ApiConstants.members(deviceId), authRequired: true);
    return (data as List).map((e) => DeviceMember.fromJson(e)).toList();
  }
}

class TeamMembersController extends ChangeNotifier {
  TeamMembersController({TeamMembersRepository? repository})
      : _repo = repository ?? TeamMembersRepository();

  final TeamMembersRepository _repo;

  LoadStatus status = LoadStatus.loading;
  List<DeviceMember> members = [];
  String? error;

  bool isInviting = false;
  String? inviteError;

  Future<bool> inviteMember(String deviceId, String email) async {
    isInviting = true;
    inviteError = null;
    notifyListeners();

    try {
      await _repo.invite(deviceId, email);
      await refresh(deviceId);
      return true;
    } on ApiException catch (e) {
      inviteError = e.message;
      return false;
    } finally {
      isInviting = false;
      notifyListeners();
    }
  }

  Future<void> load(String deviceId) async {
    status = LoadStatus.loading;
    notifyListeners();

    try {
      members = await _repo.fetchFor(deviceId);
      status = LoadStatus.success;
    } on ApiException catch (e) {
      error = e.message;
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> refresh(String deviceId) => load(deviceId);

  // DELETE MEMBER
  Future<void> deleteMember(DeviceMember member) async {
    final index = members.indexOf(member);
    members.remove(member);
    notifyListeners();

    try {
      await _repo.remove(member.deviceId, member.user.id);
    } on ApiException catch (e) {
      members.insert(index, member); // rollback on failure
      error = e.message;
      notifyListeners();
      rethrow;
    }
  }
}