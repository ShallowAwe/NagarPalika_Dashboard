import 'package:flutter/material.dart';

class UserTableHeader extends StatelessWidget {
  final int total;
  final int currentPage;
  final int totalPages;

  const UserTableHeader({
    super.key,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.people),
              const SizedBox(width: 8),
              Text('Users ($total)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          if (totalPages > 1)
            Text('Page ${currentPage + 1} of $totalPages', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
