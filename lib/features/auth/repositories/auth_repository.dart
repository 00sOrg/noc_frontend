import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sos/shared/providers/secure_storage_provider.dart';
// import 'package:sos/shared/services/push_notification_service.dart';
import 'package:sos/shared/utils/http_helpers.dart';
import 'package:sos/shared/utils/log_util.dart';

class AuthRepository {
  final String baseUrl = dotenv.env['BASE_URL']!;
  final GoogleSignIn _googleSignIn;
  final FlutterSecureStorage secureStorage;

  AuthRepository(this.secureStorage)
      : _googleSignIn = GoogleSignIn(
          clientId: dotenv.env['GOOGLE_SIGN_IN_ID'],
        );

  // Google 로그인
  Future<bool> googleLogin() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return false;

      final auth = await account.authentication;
      final googleAccessToken = auth.accessToken;
      if (googleAccessToken == null) return false;

      debugPrint('Google Login 성공: ${account.email}');
      debugPrint('AccessToken: ${auth.accessToken}');

      // TODO: 서버에 token 보내서 자체 인증 처리
      // ✅ 서버에 구글 accessToken 전송
      final response = await makePostRequest(
        Uri.parse('$baseUrl/auth/google-login'),
        {'access_token': googleAccessToken},
        'googleLogin',
      );

      // ✅ 서버에서 JWT 토큰 수신 후 저장
      final jwtToken = jsonDecode(response.body)['data']['access_token'];
      await secureStorage.write(key: 'access_token', value: jwtToken);
      debugPrint('JWT 저장 완료: $jwtToken');

      return true;
    } catch (e) {
      LogUtil.e('googleLogin 에러: $e');
      return false;
    }
  }

  //  Google 로그아웃
  Future<void> googleLogout() async {
    try {
      await _googleSignIn.signOut();
      await secureStorage.delete(key: 'access_token');
      debugPrint('Google + JWT 로그아웃 완료');
    } catch (e) {
      LogUtil.e('googleLogout 에러: $e');
    }
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<void> removeAccessToken() async {
    await secureStorage.delete(key: 'access_token');
  }

  Future<bool> checkEmail(String email) async {
    final url = Uri.parse('$baseUrl/auth/check-email?email=$email');
    try {
      await makeGetRequest(url, 'checkEmail');
      return true;
    } catch (e) {
      LogUtil.e('checkEmail 에러: $e');
      return false;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.read(secureStorageProvider);
  return AuthRepository(secureStorage);
});
