import 'package:flutter/material.dart';

class UserTablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int itemCount;
  final int itemsPerPage;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(int) onPageChanged;

  const UserTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.itemCount,
    required this.itemsPerPage,
    required this.onNext,
    required this.onPrev,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final start = (currentPage * itemsPerPage) + 1;
    final end = ((currentPage + 1) * itemsPerPage).clamp(0, itemCount);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing $start - $end of $itemCount users'),
          Row(
            children: [
              IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
              ...List.generate(totalPages, (index) {
                final isCurrent = index == currentPage;
                return TextButton(
                  onPressed: () => onPageChanged(index),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? Colors.blue : Colors.grey,
                    ),
                  ),
                );
              }),
              IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
            ],
          ),
        ],
      ),
    );
  }
}
