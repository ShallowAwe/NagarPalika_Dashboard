import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/utils/piCharItem.dart';
import 'package:smart_nagarpalika_dashboard/widgets/dashboardCard.dart';
import 'package:smart_nagarpalika_dashboard/widgets/piecharlegendItem.dart';

class StatusPieChart extends StatelessWidget {
  final List<PieChartItem> data;
  final DateTime currentMonth;

  const StatusPieChart({
    super.key,
    required this.data,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: "Status Overview",
      subtitle: "${currentMonth.month}/${currentMonth.year}",
      iconData: Icons.pie_chart,
      iconColor: Colors.green.shade700,
      iconBackgroundColor: Colors.green.shade100,
      gradientColors: [Colors.white, const Color.fromARGB(255, 226, 241, 227)],
      actionButton: IconButton(
        onPressed: () {
          // Handle refresh action
        },
        icon: Icon(Icons.refresh, color: Colors.grey.shade600),
      ),
      child: _buildPieChart(),
    );
  }

  Widget _buildPieChart() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 35,
              sections: data.map((item) {
                return PieChartSectionData(
                  color: item.color,
                  value: item.value,
                  title: '${item.value.toInt()}%',
                  titleStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  radius: 65,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PieChartLegendItem(
                  color: item.color,
                  label: item.label,
                  value: '${item.value.toInt()}%',
                  count: '${item.count} tickets',
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
