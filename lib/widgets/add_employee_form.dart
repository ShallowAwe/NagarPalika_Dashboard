import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AddEmployeeForm extends StatefulWidget {
  const AddEmployeeForm({super.key});

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final Logger _logger = Logger();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _wardsController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _assignedComplaintsController =
      TextEditingController();

  String? _selectedDepartmentCode;
  List<Map<String, dynamic>> _departments = [];

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _wardsController.dispose();
    _contactInfoController.dispose();
    _assignedComplaintsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 16,
        color: const Color(0xFFF8FAFF),
        shadowColor: Colors.blueAccent.withAlpha(21),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.grey,
                    size: 28,
                  ),
                  splashRadius: 22,
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Add New Employee',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF397DE1),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 60,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: Color(0xFF397DE1).withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE3E8F0),
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter first name'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter last name'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: _selectedDepartmentCode,
                          decoration: InputDecoration(
                            labelText: 'Department',
                            prefixIcon: const Icon(Icons.business),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: _departments
                              .map(
                                (dept) => DropdownMenuItem<String>(
                                  value: dept['code'] as String,
                                  child: Text(
                                    dept['displayName'] ?? dept['code'],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartmentCode = value;
                            });
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Select department'
                              : null,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _wardsController,
                                decoration: InputDecoration(
                                  labelText: 'Wards',
                                  prefixIcon: const Icon(Icons.map),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  helperText:
                                      'Comma-separated (e.g. Ward 1, Ward 2)',
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _contactInfoController,
                                decoration: InputDecoration(
                                  labelText: 'Contact Info',
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  helperText: 'Phone or email',
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 18),
                        // TextFormField(
                        //   controller: _assignedComplaintsController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Assigned Complaints',
                        //     prefixIcon: const Icon(Icons.assignment),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(16),
                        //     ),
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     helperText: 'Comma-separated complaint IDs',
                        //   ),
                        // ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            style:
                                ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF397DE1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.blueAccent.withAlpha(
                                    21, // 21 is the alpha value for 0.18
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ).copyWith(
                                  overlayColor:
                                      WidgetStateProperty.resolveWith<Color?>((
                                        states,
                                      ) {
                                        if (states.contains(
                                          WidgetState.pressed,
                                        )) {
                                          return Colors.blueAccent.withAlpha(
                                            18,
                                          );
                                        }
                                        if (states.contains(
                                          WidgetState.hovered,
                                        )) {
                                          return Colors.blueAccent.withAlpha(
                                            21, // 21 is the alpha value for 0.18
                                          );
                                        }
                                        return null;
                                      }),
                                ),
                            onPressed: () {
                              _createEmployee();
                            },
                            label: const Text('Create Employee'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchDepartments() async {
    final username = 'admin';
    final password = 'admin';
    try {
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      final response = await http.get(
        Uri.parse('http://localhost:8080/admin/departments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _departments = data
              .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList();
          if (_departments.isNotEmpty) {
            _selectedDepartmentCode = _departments.first['code'];
          }
        });
      } else {
        _logger.e(
          'Failed to fetch departments: Status: ${response.statusCode}, Body: ${response.body}',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to fetch departments: Status \\${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e, stack) {
      _logger.e(
        'Exception in _fetchDepartments: Error: ${e.toString()}, Stack: ${stack.toString()}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching departments: \\${e.toString()}'),
        ),
      );
    }
  }

  Future<void> _createEmployee() async {
    final username = 'admin';
    final password = 'admin';
    try {
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));
      _logger.d(
        'Auth header: Basic ' +
            base64Encode(utf8.encode('$username:$password')),
      );
      final response = await http.post(
        Uri.parse('http://localhost:8080/admin/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode({
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
          'mobile': _contactInfoController.text,
          'department': _selectedDepartmentCode,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee created successfully')),
        );
        Navigator.of(context).pop();
      } else {
        _logger.e(
          'Failed to create employee: Status: ${response.statusCode}, Body: ${response.body}',
        );
        String errorMsg = 'Failed to create employee';
        try {
          final errorJson = jsonDecode(response.body);
          if (errorJson is Map && errorJson['message'] != null) {
            errorMsg = errorJson['message'];
          } else {
            errorMsg = response.body;
          }
        } catch (_) {
          errorMsg = response.body;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: \\${errorMsg}')));
      }
    } catch (e, stack) {
      _logger.e(
        'Exception in _createEmployee: Error: ${e.toString()}, Stack: ${stack.toString()}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating employee: \\${e.toString()}')),
      );
    }
  }
}
