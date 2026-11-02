import '../../core/constant/api_constants.dart';
import '../../core/network/api_client.dart';
import '../model/fire_station.dart';

class FireStationService {
  final ApiClient _client;
  FireStationService(this._client);

  Future<List<FireStation>> getFireStations() async {
    final data = await _client.get(ApiConstants.fireStations);
    final list = data as List;
    return list
        .map((e) => FireStation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// [alertId] is the already-`verified_fire` alert this notification is
  /// for - required by the API (a 400 comes back otherwise, since the docs
  /// specify `alertId` as a required body field).
  Future<void> notifyFireStation(String id, {required String alertId}) async {
    await _client.post(
      ApiConstants.notifyFireStation(id),
      {'alertId': alertId},
      authRequired: true,
    );
  }
}