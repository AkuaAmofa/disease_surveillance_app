import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';
import '../sources/profile_remote_source.dart';

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  return ProfileRemoteSource(ref.watch(apiClientProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(profileRemoteSourceProvider));
});

class ProfileRepository {
  final ProfileRemoteSource _source;

  ProfileRepository(this._source);

  Future<UserModel> getCurrentUser() => _source.fetchCurrentUser();

  Future<UserModel> updateProfile(int userId, Map<String, dynamic> data) =>
      _source.updateProfile(userId, data);
}
