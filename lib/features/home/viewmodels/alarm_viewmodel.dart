import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/features/home/repositories/alarm_repository.dart';
import 'package:sos/features/post/repositories/post_repository.dart';
import 'package:sos/shared/models/alarm.dart';
import 'package:sos/shared/providers/user_repository_provider.dart';
import 'package:sos/shared/repositories/user_repository.dart';

class AlarmViewModel extends StateNotifier<List<Alarm>> {
  final AlarmRepository alarmRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;

  AlarmViewModel(
    this.alarmRepository,
    this.postRepository,
    this.userRepository,
  ) : super([]) {
    fetchAlarms();
  }

  Future<void> fetchAlarms() async {
    final fetchedAlarms = await alarmRepository.getAlarms();
    state = fetchedAlarms;
  }

  Future<void> markAsRead(int notificationId) async {
    final success = await alarmRepository.patchAlarmRead(notificationId);

    if (success) {
      // Re-fetch the updated alarms list after marking as read
      final updatedAlarms = await alarmRepository.getAlarms();
      state = updatedAlarms;
    }
  }
}

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepository();
});

final alarmViewModelProvider =
    StateNotifierProvider<AlarmViewModel, List<Alarm>>((ref) {
  final alarmRepository = ref.read(alarmRepositoryProvider);
  final postRepository = ref.read(postRepositoryProvider);
  final userRepository = ref.read(userRepositoryProvider);
  return AlarmViewModel(
    alarmRepository,
    postRepository,
    userRepository,
  );
});
