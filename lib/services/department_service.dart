// lib/services/department_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'service_base.dart';
import '../model/department_model.dart'; // Add this import for Department model

class DepartmentService {
  static final Logger _logger = Logger();

  static Future<List<Department>> fetchDepartments() async {
    final uri = Uri.parse('$baseUrl/get_departments_admin');
    final response = await http.get(uri, headers: getAuthHeaders());

    _logger.d('Department API Response - Status: ${response.statusCode}');
    _logger.d('Department API Response - Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final departments = data
          .map<Department>((dep) => Department.fromJson(dep))
          .toList();
      _logger.i(
        'Fetched departments: ${departments.length} departments retrieved',
      );
      return departments;
    } else {
      _logger.e('Failed to load departments: ${response.statusCode}');
      throw Exception('Failed to load departments');
    }
  }

  static Future<Department> createDepartment({required String name}) async {
    final uri = Uri.parse('$baseUrl/departments');
    final payload = jsonEncode({
      'name': name,
    });

    _logger.i('Creating department with payload: $payload');
    final response = await http.post(
      uri,
      headers: getAuthHeaders(),
      body: payload,
    );

    _logger.d('Create Department - Status: ${response.statusCode}');
    _logger.d('Create Department - Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Department.fromJson(data);
    }

    throw Exception('Failed to create department: HTTP ${response.statusCode}');
  }
}
