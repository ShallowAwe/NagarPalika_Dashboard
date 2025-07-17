import 'package:flutter/material.dart';

Widget buildComplaintBadge(int complaints) {
  Color bgColor = complaints == 0
      ? Colors.green.shade100
      : complaints <= 2
          ? Colors.orange.shade100
          : Colors.red.shade100;
  Color textColor = complaints == 0
      ? Colors.green.shade800
      : complaints <= 2
          ? Colors.orange.shade800
          : Colors.red.shade800;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
    child: Text(
      complaints.toString(),
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    ),
  );
}

Widget buildStatusBadge(bool isActive) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isActive ? Colors.green.shade100 : Colors.red.shade100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: isActive ? Colors.green : Colors.red),
        const SizedBox(width: 6),
        Text(
          isActive ? "Active" : "Inactive",
          style: TextStyle(
            color: isActive ? Colors.green.shade800 : Colors.red.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
