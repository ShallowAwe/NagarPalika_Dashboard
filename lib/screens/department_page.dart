import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/department_model.dart';
import 'package:smart_nagarpalika_dashboard/providers/department_provider.dart';
import 'package:smart_nagarpalika_dashboard/utils/summaryCards.dart';
import 'package:smart_nagarpalika_dashboard/widgets/quickaction_cards.dart';

class DepartmentPage extends ConsumerStatefulWidget {
  const DepartmentPage({super.key});

  @override
  ConsumerState<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends ConsumerState<DepartmentPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  void _refreshDepartments() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;

    setState(() {
      _showLeftArrow = _scrollController.offset > 0;
      _showRightArrow =
          _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    if (!_scrollController.hasClients) return;

    final newOffset = (_scrollController.offset - 200).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    if (!_scrollController.hasClients) return;

    final newOffset = (_scrollController.offset + 200).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

    // action cards
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
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildQuickActionCard(
                  icon: Icons.add_alert_sharp,
                  title: 'Alerts',
                  subtitle: 'View all alerts',
                  color: Colors.green,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: buildQuickActionCard(
                  icon: Icons.add_location_alt_outlined,
                  title: 'Local Bodies',
                  subtitle: 'View all local bodies',
                  color: Colors.orange,
                  onTap: () {},
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
          // Handle keyboard events properly to prevent conflicts
          return KeyEventResult.handled;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildScrollControls(),
              const SizedBox(height: 12),
              _buildScrollableCards(departmentsList),
              if (departmentsList.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: _buildScrollIndicator(departmentsList.length),
                ),
              ],
              // yet to decide on this part .//./././/.////./
              const SizedBox(height: 20),
              // action cards (create department ), alerts (complaints)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: actionCard,
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

  Widget _buildScrollControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            'Departments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _buildScrollButton(
                isVisible: _showLeftArrow,
                onPressed: _showLeftArrow ? _scrollLeft : null,
                icon: Icons.arrow_back_ios,
                tooltip: 'Scroll Left',
              ),
              const SizedBox(width: 8),
              _buildScrollButton(
                isVisible: _showRightArrow,
                onPressed: _showRightArrow ? _scrollRight : null,
                icon: Icons.arrow_forward_ios,
                tooltip: 'Scroll Right',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScrollButton({
    required bool isVisible,
    required VoidCallback? onPressed,
    required IconData icon,
    required String tooltip,
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(30),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          color: Colors.blue.shade700,
          tooltip: tooltip,
        ),
      ),
    );
  }

  Widget _buildScrollableCards(List<Department> departmentsList) {
    return SizedBox(
      height: 120,
      child: RawScrollbar(
        controller: _scrollController,

        // thumbColor: Colors.blue.shade300,
        // trackColor: Colors.grey.shade200,
        // trackBorderColor: Colors.grey.shade300,
        radius: const Radius.circular(8),
        thickness: 6,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildDepartmentCards(departmentsList),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator(int totalDepartments) {
    if (totalDepartments <= 3) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _scrollController,
      builder: (context, child) {
        double scrollProgress = 0.0;

        // null safety checks
        if (_scrollController.hasClients &&
            _scrollController.position.hasContentDimensions &&
            _scrollController.position.maxScrollExtent > 0 &&
            _scrollController.position.maxScrollExtent.isFinite) {
          scrollProgress =
              (_scrollController.offset /
                      _scrollController.position.maxScrollExtent)
                  .clamp(0.0, 1.0);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.3,
                child: Transform.translate(
                  offset: Offset(scrollProgress * 70, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildDepartmentCards(List<Department> departments) {
  return Row(
    children: departments.map((department) {
      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: SummaryCard(
          title: department.name,
          subtitle: '${department.name.length}',
          icon: Icons.business,
          iconBgColor: Colors.blue.shade100,
        ),
      );
    }).toList(),
  );
}
