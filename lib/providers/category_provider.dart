import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/category_model.dart';
import '../services/category_service.dart';

class CategoryNotifier extends AsyncNotifier<List<Categories>> {
  @override
  Future<List<Categories>> build() async {
    return await CategoryService.fetchCategories();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => CategoryService.fetchCategories());
  }

  Future<void> create(String name, {File? image}) async {
    state = const AsyncLoading();
    try {
      await CategoryService.createCategory(name: name, imageFile: image);
      final updated = await CategoryService.fetchCategories();
      state = AsyncData(updated);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Categories>>(CategoryNotifier.new);
