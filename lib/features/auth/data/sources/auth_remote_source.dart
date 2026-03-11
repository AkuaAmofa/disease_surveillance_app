import '../../../../core/network/api_client.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

class AuthRemoteSource {
  final ApiClient _client;

  AuthRemoteSource(this._client);

  Future<AuthTokenModel> login(String email, String password) async {
    final response = await _client.post(
      '/api/auth-token/',
      data: {'username': email, 'password': password},
    );
    return AuthTokenModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<UserModel> fetchCurrentUser() async {
    final response = await _client.get('/api/v1/users/me/');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  // TODO: Endpoint not available in backend yet. Sign-up must be done via Django admin or allauth web.
  Future<void> signUp({
    required String email,
    required String fullName,
    required String password,
  }) async {
    throw UnimplementedError(
      'Sign-up API endpoint does not exist in the backend. '
      'Create users via Django admin or allauth.',
    );
  }
}
