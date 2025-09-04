import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/location_model.dart';
import '../services/location_service.dart';

class LocationNotifier extends AsyncNotifier<List<Location>> {
  @override
  Future<List<Location>> build() async {
    return await LocationService.fetchLocations();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => LocationService.fetchLocations());
  }

  Future<void> create({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int categoryId,
  }) async {
    state = const AsyncLoading();
    try {
      await LocationService.createLocation(
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        categoryId: categoryId,
      );
      final updated = await LocationService.fetchLocations();
      state = AsyncData(updated);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final locationProvider =
    AsyncNotifierProvider<LocationNotifier, List<Location>>(LocationNotifier.new);
