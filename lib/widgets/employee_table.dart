import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:smart_nagarpalika_dashboard/widgets/details_popup.dart';

class EmployeeTable extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeTable({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    Logger _logger = Logger();
    _logger.i('Building EmployeeTable with ${employees.length} employees');
    _logger.d('Employee data: $employees');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable2(
          columnSpacing: 16,
          horizontalMargin: 16,
          minWidth: 800,
          headingRowHeight: 60,
          dataRowHeight: 70,
          showCheckboxColumn: false,
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => Colors.blue.shade50,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          columns: [
            DataColumn2(

              label: Text('ID', style: _headerStyle),
              size: ColumnSize.S,
              fixedWidth: 80,
              
            ),
            DataColumn2(
              label: Text('Name', style: _headerStyle),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('Username', style: _headerStyle),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Phone', style: _headerStyle),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Department', style: _headerStyle),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Text('Actions', style: _headerStyle),
              size: ColumnSize.M,
              fixedWidth: 160,
            ),
          ],
          rows: employees
              .asMap()
              .entries
              .map((entry) => _buildDataRow(context, entry.value, entry.key))
              .toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Employee emp, int rowIndex) {
    Logger _logger = Logger();
    _logger.d(
      'Building row for employee: ID=${emp.id}, Name=${emp.firstName} ${emp.lastName}',
    );
    _logger.i('Employee details: $emp');

    return DataRow(
      color: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.blue.shade50.withAlpha(135);
        }
        if (states.contains(WidgetState.selected)) {
          return Colors.blue.shade100.withAlpha(135);
        }
        return rowIndex.isEven ? Colors.white : Colors.grey.shade50;
      }),
      cells: [
        DataCell(
          onTap: () => _showEmployeeDetails(context, emp),
          
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              emp.id.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
        ),
        DataCell(
          onTap: () => _showEmployeeDetails(context, emp),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: 18,
                //   backgroundColor: Colors.blue.shade100,
                //   child: Text(
                //     '${emp.firstName.isNotEmpty ? emp.firstName[0] : ''}${emp.lastName.isNotEmpty ? emp.lastName[0] : ''}',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.blue.shade700,
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${emp.firstName} ${emp.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Employee #${emp.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          onTap: () => _showEmployeeDetails(context, emp),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              emp.firstName, // Username placeholder
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          onTap: () => _showEmployeeDetails(context, emp),
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    emp.contactInfo,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Tooltip(
                //   message: 'Copy phone',
                //   child: InkWell(
                //     borderRadius: BorderRadius.circular(6),
                //     onTap: () async {
                //       await Clipboard.setData(ClipboardData(text: emp.contactInfo));
                //       ScaffoldMessenger.of(context).clearSnackBars();
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text('Phone number copied'),
                //           duration: Duration(milliseconds: 900),
                //         ),
                //       );
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(4.0),
                //       child: Icon(
                //         Icons.copy_rounded,
                //         size: 16,
                //         color: Colors.blueGrey.shade400,
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
        DataCell(
          onTap: () => _showEmployeeDetails(context, emp),
          Container(
            alignment: Alignment.centerLeft,
            child: _buildDepartmentChip(emp.department),
          ),
        ),
        DataCell(
          onTap: () => _showEmployeeDetails(context, emp),
          Container(
            alignment: Alignment.centerLeft,
            child: _buildActionButtons(context, emp),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentChip(String department) {
    Logger _logger = Logger();
    _logger.d('Building department chip for: $department');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade100, Colors.orange.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200, width: 0.5),
      ),
      child: Text(
        department,
        style: TextStyle(
          color: Colors.orange.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Employee emp) {
    Logger _logger = Logger();
    _logger.d('Building action buttons for employee: ID=${emp.id}');

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: _buildActionButton(
            onPressed: () => _showEmployeeDetails(context, emp),
            icon: Icons.visibility_outlined,
            label: 'View',
            color: Colors.blue,
            empId: emp.id,
            action: 'View',
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: _buildActionButton(
            onPressed: () {
              _logger.i('Assign button pressed for employee: ID=${emp.id}');
              // Assign department logic
            },
            icon: Icons.assignment_outlined,
            label: 'Assign',
            color: Colors.green,
            empId: emp.id,
            action: 'Assign',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required int empId,
    required String action,
  }) {
    return Tooltip(
      message: '$action Employee',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
                      child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: color.withAlpha(35),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: color.withAlpha(45), width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 12,
                    color: color,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  void _showEmployeeDetails(BuildContext context, Employee emp) {
    Logger _logger = Logger();
    _logger.i('Showing employee details for: ID=${emp.id}');
    
    showDialog(
      context: context,
      builder: (context) => DetailsPopup(employee: emp),
    );
  }
}

const _headerStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 14,
  color: Color(0xFF2C3E50),
  letterSpacing: 0.5,
);