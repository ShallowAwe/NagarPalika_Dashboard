import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Generic expandable list widget
class ExpandableListWidget<T> extends StatelessWidget {
  final AsyncValue<List<T>> state;
  final List<T> list;
  final String title;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final VoidCallback onRefresh;
  final Widget?  Function(T item, int index) itemBuilder;
  final IconData headerIcon;
  final Color headerIconColor;
  final Color headerBackgroundColor;
  final String emptyMessage;
  final String errorMessage;

  const ExpandableListWidget({
    super.key,
    required this.state,
    required this.list,
    required this.title,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.onRefresh,
    required this.itemBuilder,
    this.headerIcon = Icons.list,
    this.headerIconColor = Colors.blue,
    this.headerBackgroundColor = Colors.white,
    this.emptyMessage = 'No items found',
    this.errorMessage = 'Failed to load items',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          // Header + Refresh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onToggleExpansion,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        headerIcon,
                        size: 20,
                        color: headerIconColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$title (${list.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh_rounded, color: Colors.blue.shade700),
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // State handling
          if (state.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (state.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade400,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ],
                ),
              ),
            )
          else if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      color: Colors.grey.shade400,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      emptyMessage,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, index) => itemBuilder(list[index], index),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
        ],
      ),
    );
  }
}