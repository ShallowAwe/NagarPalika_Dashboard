import 'package:flutter/material.dart';

// Data model for sidebar items
class SidebarItem {
  final IconData icon;
  final String label;
  final int index;
  final Color? color;

  const SidebarItem({
    required this.icon,
    required this.label,
    required this.index,
    this.color,
  });
}

class Sidebar extends StatelessWidget {
  final String username;
  final int selectedIndex;
  final Function(int)? onItemSelected;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const Sidebar({
    super.key,
    required this.username,
    required this.selectedIndex,
    this.onItemSelected,
    this.isExpanded = true,
    this.onToggle,
  });

  // Define your sidebar items here
  static const List<SidebarItem> _items = [
    SidebarItem(icon: Icons.dashboard_rounded, label: "Dashboard", index: 0),
    SidebarItem(icon: Icons.people_rounded, label: "Users", index: 1),
    SidebarItem(icon: Icons.report_rounded, label: "Complaints", index: 2),
    SidebarItem(icon: Icons.work_rounded, label: "Employees", index: 3),
    SidebarItem(icon: Icons.settings_rounded, label: "Departments", index: 4),
    SidebarItem(icon: Icons.notifications_active, label: "Alerts", index: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? 260 : 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.blue.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        children: [
          SidebarHeader(isExpanded: isExpanded, onToggle: onToggle),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SidebarNavItem(
                    item: item,
                    isSelected: selectedIndex == item.index,
                    isExpanded: isExpanded,
                    onTap: () => onItemSelected?.call(item.index),
                  ),
                );
              },
            ),
          ),
          SidebarFooter(isExpanded: isExpanded, username: username),
        ],
      ),
    );
  }
}

// Sidebar Header Component
class SidebarHeader extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onToggle;

  const SidebarHeader({super.key, required this.isExpanded, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade600, Colors.blue.shade800],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Admin Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Management System",
                    style: TextStyle(
                      color: Colors.white.withAlpha(204),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (onToggle != null)
            IconButton(
              onPressed: onToggle,
              icon: Icon(
                isExpanded ? Icons.menu_open : Icons.menu,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

// Individual Navigation Item Component
class SidebarNavItem extends StatefulWidget {
  final SidebarItem item;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback? onTap;

  const SidebarNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.isExpanded,
    this.onTap,
  });

  @override
  State<SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<SidebarNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.blue.shade600, Colors.blue.shade500],
                      )
                    : _isHovered
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.blue.shade100, Colors.blue.shade50],
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? Colors.white.withAlpha(50)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.item.icon,
                            color: widget.isSelected
                                ? Colors.white
                                : _isHovered
                                ? Colors.blue.shade700
                                : Colors.grey.shade700,
                            size: 24,
                          ),
                        ),
                        if (widget.isExpanded) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.item.label,
                              style: TextStyle(
                                color: widget.isSelected
                                    ? Colors.white
                                    : _isHovered
                                    ? Colors.blue.shade700
                                    : Colors.grey.shade800,
                                fontSize: 16,
                                fontWeight: widget.isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (widget.isSelected)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Sidebar Footer Component
class SidebarFooter extends StatelessWidget {
  final bool isExpanded;
  final String username;

  const SidebarFooter({
    super.key,
    required this.isExpanded,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.person, color: Colors.blue.shade700, size: 24),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    "Online",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle logout or settings
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Usage Example
class SidebarExample extends StatefulWidget {
  final String username;
  const SidebarExample({super.key, required this.username});

  @override
  State<SidebarExample> createState() => _SidebarExampleState();
}

class _SidebarExampleState extends State<SidebarExample> {
  int selectedIndex = 0;
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            username: widget.username,
            selectedIndex: selectedIndex,
            isExpanded: isExpanded,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            onToggle: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Center(
                child: Text(
                  'Content Area - Selected: $selectedIndex',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
