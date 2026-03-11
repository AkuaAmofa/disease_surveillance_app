import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileRemoteSource {
  final ApiClient _client;

  ProfileRemoteSource(this._client);

  Future<UserModel> fetchCurrentUser() async {
    final response = await _client.get('/api/v1/users/me/');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> updateProfile(int userId, Map<String, dynamic> data) async {
    final response = await _client.patch('/api/v1/users/$userId/', data: data);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
