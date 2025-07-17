import 'package:flutter/material.dart';

class PieChartItem {
  final String label;
  final double value;
  final int count;
  final Color color;

  const PieChartItem({
    required this.label,
    required this.value,
    required this.count,
    required this.color,
  });
}