import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/department_model.dart';
import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:smart_nagarpalika_dashboard/providers/department_provider.dart';
import 'package:smart_nagarpalika_dashboard/providers/employee_provider.dart';
import 'package:smart_nagarpalika_dashboard/services/department_service.dart';
import 'package:smart_nagarpalika_dashboard/utils/button.dart';
import 'package:smart_nagarpalika_dashboard/utils/searchBar.dart';
import 'package:smart_nagarpalika_dashboard/utils/summaryCards.dart';
import 'package:smart_nagarpalika_dashboard/widgets/add_employee_form.dart';
import 'package:smart_nagarpalika_dashboard/widgets/employee_table.dart';

class EmployeeManagementPage extends ConsumerStatefulWidget {
  const EmployeeManagementPage({super.key});

  @override
  ConsumerState<EmployeeManagementPage> createState() =>
      _EmployeeManagementPageState();
}

class _EmployeeManagementPageState
    extends ConsumerState<EmployeeManagementPage> {
  String selectedDepartment = 'ALL_DEPARTMENTS'; // Use code for internal value
  String selectedStatus = 'All Statuses'; // Example for status filter
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming departmentProvider returns List<Department>; if it returns JSON, parse here
    final List<Department> departments =
        ref.watch(departmentProvider).valueOrNull ?? [];

    final List<Employee> employees =
        ref.watch(employeeProvider).valueOrNull ?? [];

    // Apply filters
    List<Employee> filteredEmployees = employees.where((employee) {
      final matchesDepartment =
          selectedDepartment == 'ALL_DEPARTMENTS' ||
          employee.department.toUpperCase() == selectedDepartment.toUpperCase();
      final matchesSearch = employee.firstName.toLowerCase().contains(
        searchQuery,
      ); // Adjust to your Employee fields
      final matchesLastName =
          selectedStatus == 'All Statuses' ||
          employee.lastName.toLowerCase().contains(
            searchQuery,
          ); // Assuming status is a string in Employee
      return matchesDepartment && matchesSearch && matchesLastName;
    }).toList();

    // Example statuses (adjust to your app's needs)
    final List<String> statuses = [
      'All Statuses',
      'Active',
      'Inactive',
      'On Leave',
      'Suspended',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFECF6FE),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (unchanged from previous)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(25),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.people_alt,
                          color: Colors.blue.shade700,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employee Management',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Manage and monitor all Employees',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CustomButton(
                    label: 'Add Employee',
                    icon: Icons.add,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddEmployeeForm(),
                      );
                    },
                    color: Colors.blue.shade600,
                    width: 150,
                    height: 48,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Filter Section (unchanged from previous, but using Department model)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(25),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters & Search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Search Bar
                      Expanded(
                        flex: 2,
                        child: Searchbar(
                          controller: searchController,
                          onTap: () {}, // Optional: Focus or other actions
                          isReadOnly: false,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Department Filter
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDepartment,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade600,
                              ),
                              isExpanded: true,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              items: [
                                // Add 'ALL_DEPARTMENTS' explicitly
                                if (!departments.any(
                                  (dept) => dept.code == 'ALL_DEPARTMENTS',
                                ))
                                  const DropdownMenuItem<String>(
                                    value: 'ALL_DEPARTMENTS',
                                    child: Text('All Departments'),
                                  ),
                                // Map actual departments (assuming Department has 'code' and 'name')
                                ...departments.map((Department dept) {
                                  return DropdownMenuItem<String>(
                                    value:
                                        dept.code, // Use unique code for value
                                    child: Text(
                                      dept.displayName,
                                    ), // Use display name
                                  );
                                }),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDepartment = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),
                      // Status Filter (example)
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedStatus,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade600,
                              ),
                              isExpanded: true,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              items: statuses.map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(status),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(status),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedStatus = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Summary Cards (updated to use filteredEmployees)
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Employees',
                          subtitle: filteredEmployees.length.toString(),
                          icon: Icons.people,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Add other cards here, e.g., based on status filters
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Employee Table Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Employee List',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Showing ${filteredEmployees.length} filtered employees',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: filteredEmployees.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.table_chart,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No employees match the filters',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Try adjusting search or department',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : EmployeeTable(employees: filteredEmployees),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.red;
      case 'On Leave':
        return Colors.orange;
      case 'Suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
