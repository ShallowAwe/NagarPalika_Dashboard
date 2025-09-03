import 'dart:convert';

import 'package:logger/logger.dart';

import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class EmployeeServices {
  final Logger _logger = Logger();

  /// Fetch all complaints using Basic Auth
  Future<List<Employee>> fetchAllEmployee() async {
    final response = await authorizedGet('/employees');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final employees = data
          .map<Employee>((json) => Employee.fromJson(json)).toList();
      _logger.i('Fetched employees: ${employees.length}  retrieved');
      return employees;
    } else if (response.statusCode == 204) {
      _logger.w('No employees found - empty response');
      return []; // No complaints
    } else {
      _logger.e('Failed to fetch employees: ${response.statusCode}');
      throw Exception('Failed to fetch Employees: ${response.statusCode}');
    }
  }
}
