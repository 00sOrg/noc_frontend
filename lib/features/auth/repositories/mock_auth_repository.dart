import 'dart:async';
import 'auth_repository.dart';
import 'package:sos/shared/models/user.dart';

class MockAuthRepository extends AuthRepository {
  MockAuthRepository(super.secureStorage);

  @override
  Future<String?> getAccessToken() async {
    return 'mock_access_token';
  }

  @override
  Future<void> setAccessToken(String token) async {
    // no-op
  }

  @override
  Future<void> removeAccessToken() async {
    // no-op
  }

  @override
  Future<bool> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<void> logoutUser() async {
    // no-op
  }

  @override
  Future<bool> checkEmail(String email) async {
    return true;
  }

  @override
  Future<bool> checkNickname(String nickname) async {
    return true;
  }

  @override
  Future<bool> signupUser(User user, String? profilePicturePath) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
