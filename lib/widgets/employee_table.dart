import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';

class EmployeeTable extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeTable({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(height: 0),
          ...employees.map((emp) => _buildRow(context, emp)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: const [
          Expanded(flex: 1, child: Text('ID', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Name', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Username', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Phone', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Department', style: _headerStyle)),
          Expanded(flex: 2, child: Text('Actions', style: _headerStyle)),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, Employee emp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(emp.id.toString())),
          Expanded(flex: 2, child: Text('${emp.firstName} ${emp.lastName}')),
          Expanded(flex: 2, child: Text(emp.firstName)), // Username logic placeholder
          Expanded(flex: 2, child: Text(emp.contactInfo)),
          Expanded(flex: 2, child: _buildDepartmentChip(emp.department)),
          Expanded(flex: 2, child: _buildActionButtons(context, emp)),
        ],
      ),
    );
  }

  Widget _buildDepartmentChip(String department) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        department,
        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Employee emp) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            // View logic
          },
          child: const Text('View'),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            // Assign department logic
          },
          child: const Text('Assign'),
        ),
      ],
    );
  }
}

const _headerStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black87,
);
