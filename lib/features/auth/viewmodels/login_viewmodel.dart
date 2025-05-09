import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/features/auth/repositories/auth_repository.dart';

class LoginState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? errorMessage;

  LoginState({
    required this.isLoggedIn,
    required this.isLoading,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  static LoginState initial() {
    return LoginState(
      isLoggedIn: false,
      isLoading: false,
      errorMessage: null,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository) : super(LoginState.initial()) {
    checkLoginStatus();
  }

  /// 로그인 URL 노출 (UI에서 사용)
  String get loginUrl => _authRepository.loginUrl;

  /// 로그인 상태 확인
  Future<void> checkLoginStatus() async {
    final token = await _authRepository.getAccessToken();
    if (token != null) {
      state = state.copyWith(isLoggedIn: true);
      debugPrint('✅ 로그인 상태 유지됨 (JWT 존재)');
    }
  }

  /// 로그아웃 처리
  Future<void> handleLogout(BuildContext context) async {
    await _authRepository.logout();
    state = state.copyWith(isLoggedIn: false);
    GoRouter.of(context).go('/login');
  }

  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await _authRepository.storeTokens(accessToken, refreshToken);
    state = state.copyWith(isLoggedIn: true);
  }

  Future<String?> getAccessToken() async {
    return await _authRepository.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await _authRepository.getRefreshToken();
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginViewModel(authRepository);
});
