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
              data: [
                BarChartItem(
                  category: 'Water',
                  value: 10,
                  color: Colors.blue,
                  totalComplaints: 20,
                  pendingComplaints: 5,
                  resolvedComplaints: 15,
                ),
                BarChartItem(
                  category: 'Road',
                  value: 15,
                  color: Colors.amber,
                  totalComplaints: 10,
                  pendingComplaints: 5,
                  resolvedComplaints: 5,
                ),
                BarChartItem(
                  category: 'Light',
                  value: 5,
                  color: Colors.yellowAccent,
                  totalComplaints: 15,
                  pendingComplaints: 10,
                  resolvedComplaints: 5,
                ),
                BarChartItem(
                  category: 'Other',
                  value: 8,
                  color: Colors.purple,
                  totalComplaints: 20,
                  pendingComplaints: 10,
                  resolvedComplaints: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: StatusPieChart(
              data: const [
                PieChartItem(
                  label: 'Resolved',
                  value: 70,
                  count: 28,
                  color: Colors.green,
                ),
                PieChartItem(
                  label: 'Pending',
                  value: 30,
                  count: 12,
                  color: Colors.red,
                ),
              ],
              currentMonth: currentMonth,
            ),
          ),
        ],
      ),
    );
  }
}
