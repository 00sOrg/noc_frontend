import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/features/auth/repositories/auth_repository.dart';
import 'package:sos/features/home/repositories/map_repository.dart';
import 'package:sos/shared/models/post.dart';

class HomeViewModel extends StateNotifier<List<Post>> {
  final MapRepository mapRepository;
  final AuthRepository authRepository;

  HomeViewModel(this.mapRepository, this.authRepository) : super([]);

  // 지도에 띄울 게시글 검색 함수 - Future를 반환하도록 수정
  Future<List<Post>> getPosts(String keyword) async {
    try {
      final postList = await mapRepository.getMapList();
      state = postList;
      return postList; // 실제로 받아온 리스트 반환
    } catch (e) {
      state = [];
      return [];
    }
  }

  // 로그인 상태 확인
  Future<bool> checkLoginStatus() async {
    return await authRepository.isLoggedIn();
  }
}

// ✅ 전역 Provider로 분리
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<Post>>((ref) {
  final mapRepository = ref.watch(mapRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return HomeViewModel(mapRepository, authRepository);
});
