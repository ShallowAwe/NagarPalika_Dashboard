import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/model/userModel.dart';

class UserTable extends StatefulWidget {
  final List<UserModel> users;
  final Function(UserModel)? onEdit;
  final Function(UserModel)? onDelete;
  final int itemsPerPage;

  const UserTable({
    super.key, 
    required this.users,
    this.onEdit,
    this.onDelete,
    this.itemsPerPage = 5,
  });

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int currentPage = 0;
  
  int get totalPages => (widget.users.length / widget.itemsPerPage).ceil();
  
  List<UserModel> get currentPageUsers {
    final startIndex = currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(0, widget.users.length);
    return widget.users.sublist(startIndex, endIndex);
  }

  void _goToPage(int page) {
    setState(() {
      currentPage = page.clamp(0, totalPages - 1);
    });
  }

  void _previousPage() {
    if (currentPage > 0) {
      _goToPage(currentPage - 1);
    }
  }

  void _nextPage() {
    if (currentPage < totalPages - 1) {
      _goToPage(currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromARGB(0, 27, 16, 16),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Users (${widget.users.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                if (totalPages > 1)
                  Text(
                    'Page ${currentPage + 1} of $totalPages',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          
          // Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowMaxHeight: 70,
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  headingRowHeight: 60,
                  headingRowColor: WidgetStateProperty.all(Colors.transparent),
                  dividerThickness: 1,
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                      label: _buildColumnHeader('ID', Icons.tag),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Name', Icons.person),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Username', Icons.account_circle),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Mobile', Icons.phone),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Email', Icons.email),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Complaints', Icons.report_problem),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Status', Icons.info),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Address', Icons.location_on),
                    ),
                    const DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  rows: currentPageUsers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final user = entry.value;
                    
                    return DataRow(
                      color: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.grey.shade50;
                          }
                          return index % 2 == 0 ? Colors.white : Colors.grey.shade50;
                        },
                      ),
                      cells: [
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 227, 242, 253),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user.id.toString(),
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user.username,
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(user.mobile),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.email, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  user.email,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getComplaintColor(user.complaints),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user.complaints.toString(),
                              style: TextStyle(
                                color: _getComplaintTextColor(user.complaints),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: user.isActive ? Colors.green.shade100 : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: user.isActive ? Colors.green : Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user.isActive ? "Active" : "Inactive",
                                  style: TextStyle(
                                    color: user.isActive ? Colors.green.shade800 : Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  user.address ?? 'null',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          PopupMenuButton<String>(
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                size: 20,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            onSelected: (value) {
                              if (value == 'edit' && widget.onEdit != null) {
                                widget.onEdit!(user);
                              } else if (value == 'delete' && widget.onDelete != null) {
                                _showDeleteConfirmation(context, user);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          
          // Pagination Controls
          if (totalPages > 1)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Items per page info
                  Text(
                    'Showing ${(currentPage * widget.itemsPerPage) + 1} - ${((currentPage + 1) * widget.itemsPerPage).clamp(0, widget.users.length)} of ${widget.users.length} users',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  // Pagination buttons
                  Row(
                    children: [
                      // Previous button
                      IconButton(
                        onPressed: currentPage > 0 ? _previousPage : null,
                        icon: const Icon(Icons.chevron_left),
                        tooltip: 'Previous page',
                      ),
                      
                      // Page numbers
                      ...List.generate(totalPages, (index) {
                        final isCurrentPage = index == currentPage;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: Material(
                            color: isCurrentPage ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () => _goToPage(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isCurrentPage ? Colors.white : Colors.grey.shade700,
                                    fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      
                      // Next button
                      IconButton(
                        onPressed: currentPage < totalPages - 1 ? _nextPage : null,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: 'Next page',
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color.fromARGB(0, 117, 117, 117)),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getComplaintColor(int complaints) {
    if (complaints == 0) return Colors.green.shade100;
    if (complaints <= 2) return Colors.orange.shade100;
    return Colors.red.shade100;
  }

  Color _getComplaintTextColor(int complaints) {
    if (complaints == 0) return Colors.green.shade800;
    if (complaints <= 2) return Colors.orange.shade800;
    return Colors.red.shade800;
  }

  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onDelete != null) {
                  widget.onDelete!(user);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}