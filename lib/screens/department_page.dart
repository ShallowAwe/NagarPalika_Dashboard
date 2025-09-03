import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/department_model.dart';
import 'package:smart_nagarpalika_dashboard/providers/department_provider.dart';
import 'package:smart_nagarpalika_dashboard/widgets/quickaction_cards.dart';
import 'package:smart_nagarpalika_dashboard/widgets/add_department.dart';

class DepartmentPage extends ConsumerStatefulWidget {
  const DepartmentPage({super.key});

  @override
  ConsumerState<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends ConsumerState<DepartmentPage> {
  bool _isDepartmentsExpanded = false;

  void _refreshDepartments() {
    setState(() {
      ref.read(departmentProvider.notifier).refresh();
    });
  }

  void _toggleDepartmentsExpansion() {
    setState(() {
      _isDepartmentsExpanded = !_isDepartmentsExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final departments = ref.watch(departmentProvider);
    final departmentsList = departments.valueOrNull ?? [];

    // Ensure proper focus management
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });

    // Quick action cards
    Widget actionCard = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: buildQuickActionCard(
                  icon: Icons.add,
                  title: 'Create Department',
                  subtitle: 'Create a new department',
                  color: Colors.blue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddDepartment(),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildQuickActionCard(
                  icon: Icons.add_location_alt_outlined,
                  title: 'Total Departments',
                  subtitle: 'View all departments',
                  color: Colors.orange,
                  onTap: _toggleDepartmentsExpansion,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Focus(
        autofocus: false,
        onKeyEvent: (node, event) {
          return KeyEventResult.handled;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: actionCard,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(25),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _toggleDepartmentsExpansion,
                              child: Text(
                                'Departments (${departmentsList.length})',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _refreshDepartments,
                              icon: Icon(Icons.refresh_rounded,
                                  color: Colors.blue.shade700),
                              tooltip: 'Refresh',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (departments.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (departments.hasError)
                          Text('Failed to load departments',
                              style: TextStyle(color: Colors.red.shade700))
                        else if (departmentsList.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Text('No departments found',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        else
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: departmentsList.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: Colors.grey.shade200,
                              ),
                              itemBuilder: (context, index) {
                                final d = departmentsList[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade50,
                                    child: Icon(Icons.business,
                                        color: Colors.blue.shade700),
                                  ),
                                  title: Text(d.name),
                                  subtitle: Text('ID: ${d.id}'),
                                );
                              },
                            ),
                            crossFadeState: _isDepartmentsExpanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withAlpha(30),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.dashboard, size: 32, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Department Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage and monitor all departments',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _refreshDepartments,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 32,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
