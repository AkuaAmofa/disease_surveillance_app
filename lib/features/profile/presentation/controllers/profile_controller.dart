import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repositories/auth_repository.dart';

/// real logged-in user 
final profileUserProvider = FutureProvider.autoDispose<UserModel>((ref) {
  return ref.watch(authRepositoryProvider).fetchCurrentUser();
});
