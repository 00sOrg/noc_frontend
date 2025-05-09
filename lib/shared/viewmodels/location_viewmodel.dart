import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sos/shared/models/location.dart';
import 'package:sos/shared/services/geolocator_service.dart';

class LocationViewModel extends StateNotifier<AsyncValue<Location>> {
  LocationViewModel() : super(const AsyncValue.loading()) {
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final position = await GeolocatorService.getCurrentPosition();
      final lat = position.latitude;
      final lon = position.longitude;

      state = AsyncValue.data(
        Location(
          latitude: lat,
          longitude: lon,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    await _fetchLocation();
  }
}

final locationViewModelProvider =
    StateNotifierProvider<LocationViewModel, AsyncValue<Location>>((ref) {
  return LocationViewModel();
});
