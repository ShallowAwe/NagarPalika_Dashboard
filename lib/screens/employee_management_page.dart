import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:smart_nagarpalika_dashboard/model/department_model.dart';
import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:smart_nagarpalika_dashboard/providers/department_provider.dart';
import 'package:smart_nagarpalika_dashboard/providers/employee_provider.dart';
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
  // ==================== STATE VARIABLES ====================
  final Logger _logger = Logger();

  // Filter state variables
  String selectedDepartment =
      'ALL_DEPARTMENTS'; // Internal value for department filter
  String selectedStatus = 'All Statuses'; // Status filter value

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // ==================== LIFECYCLE METHODS ====================
  @override
  void initState() {
    super.initState();

    // Set up search listener to update filter in real-time
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    // Clean up resources
    searchController.dispose();
    super.dispose();
  }

  // ==================== HELPER METHODS ====================

  /// Returns color based on employee status
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

  /// Builds the department dropdown with proper error handling
  Widget _buildDepartmentDropdown(List<Department> departments) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDepartment.toString(),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          // Build dropdown items with error handling
          items: _buildDepartmentDropdownItems(departments),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedDepartment = newValue;
                _logger.d('Department filter changed to: $newValue');
              });
            }
          },
        ),
      ),
    );
  }

  /// Builds department dropdown items with proper null safety
  List<DropdownMenuItem<String>> _buildDepartmentDropdownItems(
    List<Department> departments,
  ) {
    List<DropdownMenuItem<String>> items = [
      // Default "All Departments" option
      const DropdownMenuItem<String>(
        value: 'ALL_DEPARTMENTS',
        child: Text('All Departments'),
      ),
    ];

    // Add department items with null safety checks
    for (Department dept in departments) {
      if (dept.id != null && dept.name != null) {
        items.add(
          DropdownMenuItem<String>(
            value: dept.id!.toString(),
            child: Text(
              dept.name.toString(),
              overflow: TextOverflow.ellipsis, // Handle long department names
            ),
          ),
        );
      }
    }

    return items;
  }

  /// Builds the status dropdown
  Widget _buildStatusDropdown(List<String> statuses) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
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
                  Expanded(
                    child: Text(status, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedStatus = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  /// Filters employees based on current filter criteria
  List<Employee> _getFilteredEmployees(List<Employee> employees) {
    return employees.where((employee) {
      // Department filtering - handle null safety
      final matchesDepartment =
          selectedDepartment == 'ALL_DEPARTMENTS' ||
          (employee.department != null &&
              employee.department == selectedDepartment);

      // Search filtering - check both first name and last name with null safety
      final matchesSearch =
          searchQuery.isEmpty ||
          (employee.firstName?.toLowerCase().contains(searchQuery) ?? false) ||
          (employee.lastName?.toLowerCase().contains(searchQuery) ?? false);

      // Status filtering - for now just return true since status isn't in employee model
      // TODO: Implement proper status filtering when status field is added to Employee model
      final matchesStatus = selectedStatus == 'All Statuses';

      // Debug logging for department filtering
      if (selectedDepartment != 'ALL_DEPARTMENTS') {
        _logger.d(
          'Filtering - Employee: ${employee.firstName} ${employee.lastName}, '
          'Department: ${employee.department}, Selected: $selectedDepartment, '
          'Matches: $matchesDepartment',
        );
      }

      return matchesDepartment && matchesSearch && matchesStatus;
    }).toList();
  }

  // ==================== BUILD METHOD ====================
  @override
  Widget build(BuildContext context) {
    // ==================== DATA PROVIDERS ====================
    // Watch department and employee providers with proper error handling
    final departmentAsyncValue = ref.watch(departmentProvider);
    final employeeAsyncValue = ref.watch(employeeProvider);

    // Extract data with null safety
    final List<Department> departments = departmentAsyncValue.valueOrNull ?? [];
    final List<Employee> employees = employeeAsyncValue.valueOrNull ?? [];

    // Apply filters to get filtered employee list
    final List<Employee> filteredEmployees = _getFilteredEmployees(employees);

    // Status options - can be moved to a constants file later
    final List<String> statuses = [
      'All Statuses',
      'Active',
      'Inactive',
      'On Leave',
      'Suspended',
    ];

    // Handle loading states
    if (departmentAsyncValue.isLoading || employeeAsyncValue.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFECF6FE),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Handle error states
    if (departmentAsyncValue.hasError || employeeAsyncValue.hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFECF6FE),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading data: ${departmentAsyncValue.error ?? employeeAsyncValue.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Refresh data
                  ref.invalidate(departmentProvider);
                  ref.invalidate(employeeProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFECF6FE),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== HEADER SECTION ====================
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
                  // Left side - Title and subtitle with icon
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
                  // Right side - Add Employee button
                  CustomButton(
                    label: 'Add Employee',
                    icon: Icons.add,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const AddEmployeeForm(),
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

            // ==================== FILTER & CONTENT SECTION ====================
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
                  // ==================== FILTERS HEADER ====================
                  const Text(
                    'Filters & Search',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ==================== FILTER CONTROLS ROW ====================
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

                      // Department Filter Dropdown
                      Expanded(
                        flex: 1,
                        child: _buildDepartmentDropdown(departments),
                      ),

                      const SizedBox(width: 20),

                      // Status Filter Dropdown
                      Expanded(flex: 1, child: _buildStatusDropdown(statuses)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ==================== SUMMARY CARDS SECTION ====================
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
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ==================== EMPLOYEE TABLE SECTION ====================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table header with count
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
                                'Showing ${filteredEmployees.length} of ${employees.length} employees',
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

                      // Employee table container
                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: filteredEmployees.isEmpty
                              ? _buildEmptyState()
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

  // ==================== EMPTY STATE WIDGET ====================
  /// Builds the empty state when no employees match filters
  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.search_off, size: 48, color: Colors.grey),
        const SizedBox(height: 16),
        const Text(
          'No employees found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          searchQuery.isNotEmpty
              ? 'No employees match your search criteria'
              : 'Try adjusting your filters',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              selectedDepartment = 'ALL_DEPARTMENTS';
              selectedStatus = 'All Statuses';
              searchController.clear();
              searchQuery = '';
            });
          },
          child: const Text('Clear All Filters'),
        ),
      ],
    );
  }
}
