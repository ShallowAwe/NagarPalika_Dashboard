// lib/services/department_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'service_base.dart';
import '../model/department_model.dart'; // Add this import for Department model

class DepartmentService {
  static Future<List<Department>> fetchDepartments() async {
    final uri = Uri.parse('$baseUrl/departments');
    final response = await http.get(uri, headers: getAuthHeaders());

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Department>((dep) => Department.fromJson(dep)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }
}
