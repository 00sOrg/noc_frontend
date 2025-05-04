import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sos/features/auth/repositories/auth_repository.dart';
import 'package:sos/shared/utils/log_util.dart';

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

  /// Google 로그인
  Future<void> handleGoogleLogin(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      final success = await _authRepository.googleLogin();
      if (success) {
        state = state.copyWith(isLoggedIn: true, isLoading: false);
        GoRouter.of(context).go('/home');
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      LogUtil.e('handleGoogleLogin 에러: $e');
    }
  }

  /// 현재 로그인 상태 확인
  Future<void> checkLoginStatus() async {
    final token = await _authRepository.getAccessToken();
    if (token != null) {
      state = state.copyWith(isLoggedIn: true);
      debugPrint('JWT 존재: 로그인 상태');
    }
  }

  /// 로그아웃
  Future<void> handleLogout(BuildContext context) async {
    await _authRepository.googleLogout();
    state = state.copyWith(isLoggedIn: false);
    GoRouter.of(context).go('/login');
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginViewModel(authRepository);
});
