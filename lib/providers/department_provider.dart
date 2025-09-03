// lib/provider/department_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/department_model.dart';
import '../services/department_service.dart';

class DepartmentNotifier extends AsyncNotifier<List<Department>> {
  @override
  Future<List<Department>> build() async {
    return await DepartmentService.fetchDepartments();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => DepartmentService.fetchDepartments());
  }

  Future<void> create(String name) async {
    final previous = state;
    state = const AsyncLoading();
    try {
      final created = await DepartmentService.createDepartment(name: name);
      final current = await DepartmentService.fetchDepartments();
      // Prefer server as source of truth; fall back to append
      state = AsyncData(current.isNotEmpty ? current : [
        ...?previous.valueOrNull,
        created,
      ]);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final departmentProvider =
    AsyncNotifierProvider<DepartmentNotifier, List<Department>>(
      DepartmentNotifier.new,
    );
