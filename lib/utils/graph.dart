
import 'package:flutter/material.dart';

import 'package:smart_nagarpalika_dashboard/utils/barcharItems.dart';
import 'package:smart_nagarpalika_dashboard/utils/piCharItem.dart';
import 'package:smart_nagarpalika_dashboard/widgets/complaintBarChar.dart';
import 'package:smart_nagarpalika_dashboard/widgets/statusPieChart.dart';

// Main Dashboard Widget
class DashboardGraph extends StatefulWidget {
  const DashboardGraph({super.key});

  @override
  State<DashboardGraph> createState() => _DashboardGraphState();
}

class _DashboardGraphState extends State<DashboardGraph> {
  final currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ComplaintsBarChart(
              data: const [
                BarChartItem(category: 'Water', value: 10, color: Colors.blue),
                BarChartItem(category: 'Road', value: 15, color: Color.fromARGB(255, 81, 178, 85)),
                BarChartItem(category: 'Light', value: 5, color: Colors.orange),
                BarChartItem(category: 'Other', value: 8, color: Colors.purple),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: StatusPieChart(
              data: const [
                PieChartItem(label: 'Resolved', value: 70, count: 28, color: Colors.green),
                PieChartItem(label: 'Pending', value: 30, count: 12, color: Colors.red),
              ],
              currentMonth: currentMonth,
            ),
          ),
        ],
      ),
    );
  }
}