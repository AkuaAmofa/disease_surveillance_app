import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/repositories/auth_repository.dart';

class AuthState {
  final String email;
  final String password;
  final bool rememberMe;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Tracks whether the user is authenticated across the app.
/// GoRouter watches this to redirect unauthenticated users.
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref) : super(const AuthState());

  void setEmail(String value) => state = state.copyWith(email: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void toggleRememberMe() =>
      state = state.copyWith(rememberMe: !state.rememberMe);

  String? validate() {
    if (state.email.isEmpty) return 'Email is required';
    if (!state.email.contains('@')) return 'Enter a valid email';
    if (state.password.isEmpty) return 'Password is required';
    if (state.password.length < 4) return 'Password must be at least 4 characters';
    return null;
  }

  Future<bool> login() async {
    final error = validate();
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _repository.login(state.email, state.password);
      _ref.read(isAuthenticatedProvider.notifier).state = true;
      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Login failed. Check backend connection.');
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _ref.read(isAuthenticatedProvider.notifier).state = false;
    state = const AuthState();
  }

  Future<void> checkSession() async {
    final loggedIn = await _repository.isLoggedIn();
    _ref.read(isAuthenticatedProvider.notifier).state = loggedIn;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref,
  );
});
