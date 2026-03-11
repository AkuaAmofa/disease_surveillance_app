import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../sources/auth_remote_source.dart';

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSource(ref.watch(apiClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    source: ref.watch(authRemoteSourceProvider),
    client: ref.watch(apiClientProvider),
  );
});

class AuthRepository {
  final AuthRemoteSource _source;
  final ApiClient _client;

  AuthRepository({required AuthRemoteSource source, required ApiClient client})
      : _source = source,
        _client = client;

  Future<void> login(String email, String password) async {
    final tokenModel = await _source.login(email, password);
    await _client.saveToken(tokenModel.token);
  }

  Future<void> logout() async {
    await _client.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _client.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserModel> fetchCurrentUser() async {
    return _source.fetchCurrentUser();
  }
}
