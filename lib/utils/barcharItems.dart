import 'package:flutter/material.dart';

class BarChartItem {
  final String category;
  final double? value; // Keep for backward compatibility
  final Color? color; // Keep for backward compatibility
  final double totalComplaints;
  final double pendingComplaints;
  final double resolvedComplaints;
  final Color totalColor;
  final Color pendingColor;
  final Color resolvedColor;

  BarChartItem({
    required this.category,
    this.value, // Optional for backward compatibility
    this.color, // Optional for backward compatibility
    required this.totalComplaints,
    required this.pendingComplaints,
    required this.resolvedComplaints,
    Color? totalColor,
    this.pendingColor = const Color(0xFFF44336), // Red
    this.resolvedColor = const Color(0xFF4CAF50), // Green
  }) : totalColor =
           totalColor ??
           color ??
           const Color(0xFF2196F3); // Use provided color or default blue
}
