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
}

final departmentProvider =
    AsyncNotifierProvider<DepartmentNotifier, List<Department>>(
      DepartmentNotifier.new,
    );
