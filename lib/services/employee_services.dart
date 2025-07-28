import 'dart:convert';
import 'package:riverpod/riverpod.dart';

import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class EmployeeNotifier extends AsyncNotifier<List<Employee>> {
  @override
  Future<List<Employee>> build() async {
    return await _fetchEmployees();
  }

  Future<List<Employee>> _fetchEmployees() async {
    final response = await authorizedGet('/get_employees');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final employees = data.map((e) => Employee.fromJson(e)).toList();
      print('Fetched employees: ' + employees.toString()); // Debug print
      return employees;
    } else {
      throw Exception('Failed to load employees');
    }
  }

  /// Manual refresh
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchEmployees());
  }
}
