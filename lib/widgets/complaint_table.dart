import 'package:flutter/material.dart';

import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';

class Complaint_Table extends StatefulWidget {
  final List<ComplaintModel> complaints;
  final Function(ComplaintModel)? onEdit;
  final Function(ComplaintModel)? onDelete;
  final int itemsPerPage;

  const Complaint_Table({
    super.key,
    required this.complaints,
    this.onEdit,
    this.onDelete,
    this.itemsPerPage = 5,
  });

  @override
  State<Complaint_Table> createState() => _Complaint_TableState();
}

class _Complaint_TableState extends State<Complaint_Table> {
  int currentPage = 0;

  int get totalPages => (widget.complaints.length / widget.itemsPerPage).ceil();

  List<ComplaintModel> get currentPageComplaints {
    final startIndex = currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(
      0,
      widget.complaints.length,
    );
    return widget.complaints.sublist(startIndex, endIndex);
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
        color: const Color.fromARGB(201, 255, 255, 255),
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
                    Icon(Icons.report_problem, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Complaints (${widget.complaints.length})',
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
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                    DataColumn(label: _buildColumnHeader('ID', Icons.tag)),
                    DataColumn(
                      label: _buildColumnHeader(
                        'Description',
                        Icons.description,
                      ),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Category', Icons.category),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Location', Icons.location_on),
                    ),
                    DataColumn(
                      label: _buildColumnHeader(
                        'Created Date',
                        Icons.calendar_today,
                      ),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Submitted By', Icons.person),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Status', Icons.info_outline),
                    ),
                    DataColumn(
                      label: _buildColumnHeader('Images', Icons.image),
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
                  rows: currentPageComplaints.asMap().entries.map((entry) {
                    final index = entry.key;
                    final complaint = entry.value;

                    return DataRow(
                      color: WidgetStateProperty.resolveWith<Color?>((
                        Set<WidgetState> states,
                      ) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.grey.shade50;
                        }
                        return index % 2 == 0
                            ? Colors.white
                            : Colors.grey.shade50;
                      }),
                      cells: [
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 227, 242, 253),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              complaint.id.toString(),
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: complaint.description,
                            child: Container(
                              // height: 500,
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(
                                complaint.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              complaint.category,
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
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  complaint.location,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(complaint.createdAt),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  complaint.submittedBy,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(complaint.status),
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
                                    color: _getStatusIndicatorColor(
                                      complaint.status,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getStatusText(complaint.status),
                                  style: TextStyle(
                                    color: _getStatusTextColor(
                                      complaint.status,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: complaint.imageUrls.isEmpty
                                  ? Colors.grey.shade100
                                  : Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 16,
                                  color: complaint.imageUrls.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.purple.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  complaint.imageUrls.length.toString(),
                                  style: TextStyle(
                                    color: complaint.imageUrls.isEmpty
                                        ? Colors.grey.shade600
                                        : Colors.purple.shade800,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
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
                                widget.onEdit!(complaint);
                              } else if (value == 'delete' &&
                                  widget.onDelete != null) {
                                _showDeleteConfirmation(context, complaint);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
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
                    'Showing ${(currentPage * widget.itemsPerPage) + 1} - ${((currentPage + 1) * widget.itemsPerPage).clamp(0, widget.complaints.length)} of ${widget.complaints.length} complaints',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                            color: isCurrentPage
                                ? Colors.blue
                                : Colors.transparent,
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
                                    color: isCurrentPage
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: isCurrentPage
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      // Next button
                      IconButton(
                        onPressed: currentPage < totalPages - 1
                            ? _nextPage
                            : null,
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.PENDING:
        return Colors.orange.shade100;
      case ComplaintStatus.IN_PROGRESS:
        return Colors.blue.shade100;
      case ComplaintStatus.RESOLVED:
        return Colors.green.shade100;
    }
  }

  Color _getStatusIndicatorColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.PENDING:
        return Colors.orange;
      case ComplaintStatus.IN_PROGRESS:
        return Colors.blue;
      case ComplaintStatus.RESOLVED:
        return Colors.green;
    }
  }

  Color _getStatusTextColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.PENDING:
        return Colors.orange.shade800;
      case ComplaintStatus.IN_PROGRESS:
        return Colors.blue.shade800;
      case ComplaintStatus.RESOLVED:
        return Colors.green.shade800;
    }
  }

  String _getStatusText(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.PENDING:
        return 'Pending';
      case ComplaintStatus.IN_PROGRESS:
        return 'In Progress';
      case ComplaintStatus.RESOLVED:
        return 'Resolved';
    }
  }

  void _showDeleteConfirmation(BuildContext context, ComplaintModel complaint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Complaint'),
          content: Text(
            'Are you sure you want to delete complaint #${complaint.id}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onDelete != null) {
                  widget.onDelete!(complaint);
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
