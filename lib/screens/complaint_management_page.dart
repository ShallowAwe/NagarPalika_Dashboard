import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/data/dummy_complaints.dart';
import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';
import 'package:smart_nagarpalika_dashboard/utils/button.dart';
import 'package:smart_nagarpalika_dashboard/utils/searchBar.dart';
import 'package:smart_nagarpalika_dashboard/utils/summaryCards.dart';
import 'package:smart_nagarpalika_dashboard/widgets/complaint_table.dart';

class ComplaintManagementPage extends StatefulWidget {
  const ComplaintManagementPage({super.key});

  @override
  State<ComplaintManagementPage> createState() =>
      _ComplaintManagementPageState();
}

class _ComplaintManagementPageState extends State<ComplaintManagementPage> {
  String selectedDepartment = 'All Departments';
  String selectedStatus = 'Active';

  final List<String> departments = [
    'All Departments',
    'Water Supply',
    'Road Maintenance',
    'Street Lighting',
    'Garbage Collection',
  ];

  final List<String> statuses = ['Active', 'Inactive', 'On Leave', 'Suspended'];

  @override
  Widget build(BuildContext context) {
    var ifComplaintsEmpty = [
      dummyComplaints.isEmpty
          ? const Icon(Icons.table_chart, size: 48, color: Colors.grey)
          : Complaint_Table(complaints: dummyComplaints, itemsPerPage: 5),
      SizedBox(height: 16),
      Text(
        'Employee table will be displayed here',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
      SizedBox(height: 8),
      Text(
        'Table will show employee details, actions, and status',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFECF6FE),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
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
                            'Complaint Management',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Manage and monitor all Complaints',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CustomButton(
                    label: 'Add Complaint',
                    icon: Icons.add,
                    onPressed: () {},
                    color: Colors.blue.shade600,
                    width: 150,
                    height: 48,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Filter Section
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
                          controller: TextEditingController(),
                          onTap: () {},
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
                              items: departments.map((String department) {
                                return DropdownMenuItem<String>(
                                  value: department,
                                  child: Text(department),
                                );
                              }).toList(),
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

                      // Status Filter
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Complaints',
                    subtitle: dummyComplaints.length.toString(),
                    icon: Icons.people,
                    // color: Colors.blue,
                    // trend: '+2',
                    // trendUp: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Active Complaints',
                    subtitle: dummyComplaints
                        .where(
                          (complaint) =>
                              complaint.status == ComplaintStatus.PENDING,
                        )
                        .length
                        .toString(),
                    icon: Icons.check_circle,
                    // color: Colors.green,
                    // trend: '+1',
                    // trendUp: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: 'Completed Complaints',
                    subtitle: dummyComplaints
                        .where(
                          (complaint) =>
                              complaint.status == ComplaintStatus.RESOLVED,
                        )
                        .length
                        .toString(),
                    icon: Icons.person_off,
                    // color: Colors.orange,
                    // trend: '0',
                    // trendUp: false,
                  ),
                ),
                const SizedBox(width: 16),
                // Expanded(
                //   child: SummaryCard(
                //     title: 'Inactive',
                //     subtitle: '1',
                //     icon: Icons.block,
                //     // color: Colors.red,
                //     // trend: '-1',
                //     // trendUp: false,
                //   ),
                // ),
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
                      'Complaint List',
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
                          'Showing ${selectedDepartment == 'All Departments' ? 'all' : selectedDepartment} employees',
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dummyComplaints.isEmpty
                          ? ifComplaintsEmpty
                          : [
                              Expanded(
                                child: Complaint_Table(
                                  complaints: dummyComplaints,
                                  itemsPerPage: 4,
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFECF6FE),
//       body: Column(
//         children: 
//           [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(20,20,20,10),
//           child: Row(mainAxisAlignment: 
//           MainAxisAlignment.spaceBetween,
//             children: [
//             //  CustomButton(icon: Icons.add, label: 'add ', onPressed: (){}, color: const Color.fromARGB(255, 55, 156, 238)),
//               const SizedBox(width: 10),
//               const Searchbar(),
//               const SizedBox(width: 10),
//               CustomButton(icon: Icons.filter_alt_outlined, label: 'filter', onPressed: (){}, color: Colors.lightGreen)
              
//             ],
//           ),
//         ),

//         const SizedBox(height: 20),

//         // Complaint Table 
//          Flexible(child: Complaint_Table(complaints: dummyComplaints,itemsPerPage: 5,))
//       ],
        
//       ),
//     );
//   }
// }