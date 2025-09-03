import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:smart_nagarpalika_dashboard/model/department_model.dart';
import 'package:smart_nagarpalika_dashboard/model/wards_model.dart';
import 'package:smart_nagarpalika_dashboard/providers/department_provider.dart';
import 'package:smart_nagarpalika_dashboard/providers/wards_provider.dart';

class AddEmployeeForm extends ConsumerStatefulWidget {
  const AddEmployeeForm({super.key});

  @override
  ConsumerState<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends ConsumerState<AddEmployeeForm> {
  final Logger _logger = Logger();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Fixed: Use MultiSelectController properly
  final MultiSelectController<Wards> _wardsController = MultiSelectController<Wards>();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _assignedComplaintsController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String? _selectedDepartmentCode;
  // Fixed: Use List<Wards> instead of String for selected wards
  List<Wards> _selectedWards = [];
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _wardsController.dispose();
    _contactInfoController.dispose();
    _assignedComplaintsController.dispose();
    _positionController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Custom validation for MultiDropdown
  String? _validateWards() {
    if (_selectedWards.isEmpty) {
      return 'Please select at least one ward';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _departments = ref.watch(departmentProvider);
    final _wards = ref.watch(wardProvider);
      
    return Center(
      child: Card(
        elevation: 16,
        color: const Color(0xFFF8FAFF),
        shadowColor: Colors.blueAccent.withAlpha(21),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          width: 650,
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
                        Row(
                          children: [
                            Expanded(
                              child: _departments.when(
                                data: (list) {
                                  return DropdownButtonFormField<String>(
                                    value: _selectedDepartmentCode,
                                    decoration: InputDecoration(
                                      labelText: 'Department',
                                      prefixIcon: const Icon(Icons.business),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                    ),
                                    isExpanded: true,
                                    items: list.map((dept) {
                                      return DropdownMenuItem<String>(
                                        value: dept.id.toString(),
                                        child: Text(
                                          dept.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDepartmentCode = value;
                                      });
                                    },
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Select department'
                                        : null,
                                  );
                                },
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (e, st) => Text('Error: $e'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Fixed MultiDropdown implementation
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _wards.when(
                                    data: (list) {
                                      return MultiDropdown<Wards>(
                                        fieldDecoration: FieldDecoration(
                                          labelText: 'Select Wards',
                                          prefixIcon: const Icon(Icons.location_on),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                      backgroundColor: Colors.white
                                        ),
                                        dropdownDecoration: const DropdownDecoration(
                                          elevation: 5,
                                          maxHeight: 300,
                                        ),
                                        items: list
                                            .map((ward) => DropdownItem<Wards>(
                                                  value: ward,
                                                  label: ward.name,
                                                ))
                                            .toList(),
                                        controller: _wardsController,
                                        enabled: true,
                                        searchEnabled: true,
                                        chipDecoration: ChipDecoration(
                                          backgroundColor: Colors.amber.shade100,
                                          wrap: true,
                                          runSpacing: 4,
                                          spacing: 8,
                                          deleteIcon: const Icon(Icons.close, size: 18),
                                          labelStyle: const TextStyle(fontSize: 12),
                                        ),
                                        onSelectionChange: (selectedItems) {
                                          setState(() {
                                            _selectedWards = selectedItems;
                                          });
                                        },
                                     
                                      );
                                    },
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, stackTrace) => Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.red.shade200),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.error_outline, color: Colors.red.shade700),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Error loading wards: $error',
                                              style: TextStyle(color: Colors.red.shade700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Custom validation message for MultiDropdown
                                  if (_validateWards() != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, top: 5),
                                      child: Text(
                                        _validateWards()!,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: const Icon(Icons.account_circle),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  helperText: "Enter username",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter username'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                obscureText: passwordVisible,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  helperText: "Enter password",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter password'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _contactInfoController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Mobile No.',
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  helperText: 'Phone Number',
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter mobile number'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _positionController,
                                decoration: InputDecoration(
                                  labelText: "Position",
                                  prefixIcon: const Icon(Icons.work_outline_rounded),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  helperText: "Work Position",
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Enter position'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF397DE1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 4,
                              shadowColor: Colors.blueAccent.withAlpha(21),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ).copyWith(
                              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.blueAccent.withAlpha(18);
                                }
                                if (states.contains(WidgetState.hovered)) {
                                  return Colors.blueAccent.withAlpha(21);
                                }
                                return null;
                              }),
                            ),
                            onPressed: _createEmployee,
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

  Future<void> _createEmployee() async {
    // Validate form and custom MultiDropdown
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Custom validation for MultiDropdown
    if (_validateWards() != null) {
      setState(() {}); // Trigger rebuild to show validation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one ward')),
      );
      return;
    }

    const username = 'admin';
    const password = 'admin';
    
    try {
      final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      
      // Fixed payload construction
      final payload = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phoneNumber': _contactInfoController.text.trim(),
        'departmentId': int.tryParse(_selectedDepartmentCode ?? ''),
        'wardsId': _selectedWards.map((ward) => ward.id).toList(), // Fixed: Extract IDs from Ward objects
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
        'position': _positionController.text.trim(), // Fixed typo: 'postion' -> 'position'
      };

      _logger.d('Sending payload: ${jsonEncode(payload)}');
      
      final response = await http.post(
        Uri.parse('http://localhost:8080/admin/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(payload),
      );
      
      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee created successfully')),
          );
          Navigator.of(context).pop();
        }
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
          errorMsg = 'Server error: ${response.statusCode}';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: $errorMsg')),
          );
        }
      }
    } catch (e, stack) {
      _logger.e(
        'Exception in _createEmployee: Error: ${e.toString()}, Stack: ${stack.toString()}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating employee: ${e.toString()}')),
        );
      }
    }
  }
}