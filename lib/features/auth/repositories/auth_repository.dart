import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sos/shared/providers/secure_storage_provider.dart';
import 'package:sos/shared/utils/log_util.dart';

class AuthRepository {
  final FlutterSecureStorage secureStorage;
  final String baseUrl = dotenv.env['BASE_URL']!;

  AuthRepository(this.secureStorage);

  String get loginUrl => '$baseUrl/oauth2/authorization/google';

  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await secureStorage.write(key: 'access_token', value: accessToken);
    await secureStorage.write(key: 'refresh_token', value: refreshToken);
    LogUtil.i("🔑 AccessToken 저장 완료");
    LogUtil.i("🔁 RefreshToken 저장 완료");
  }

  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: 'refresh_token');
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'access_token');
    await secureStorage.delete(key: 'refresh_token');
    LogUtil.i("🧹 토큰 삭제 완료");
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStorage = ref.read(secureStorageProvider);
  return AuthRepository(secureStorage);
});
