import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/features/auth/repositories/auth_repository.dart';
import 'package:sos/shared/models/post.dart';
import 'package:sos/shared/utils/http_helpers.dart';
import 'package:sos/shared/utils/log_util.dart';

class MapRepository {
  final String baseUrl = dotenv.env['BASE_URL']!;
  final AuthRepository authRepository;

  MapRepository(this.authRepository);

  Future<List<Post>> getMapList() async {
    // TODO: 지도에 띄울 게시글만 불러오는 API 필요
    final url = Uri.parse('$baseUrl/map/events');

    try {
      final accessToken = await authRepository.getAccessToken();
      if (accessToken == null) {
        throw Exception('Unauthorized: Access token 없음');
      }

      final response = await makeGetRequest(
        url,
        'getMapList',
        accessToken: accessToken,
      );

      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        final List events = responseBody['data']['events'];

        return events.map((event) => Post.fromJson(event)).toList();
      } else {
        throw Exception('Board list fetch 실패');
      }
    } catch (e) {
      LogUtil.e('getBoardList 에러: $e');
      return [];
    }
  }
}

final mapRepositoryProvider = Provider<MapRepository>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return MapRepository(authRepository);
});
