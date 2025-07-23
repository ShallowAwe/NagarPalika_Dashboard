import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/utils/barcharItems.dart';
import 'package:smart_nagarpalika_dashboard/widgets/dashboardCard.dart';



class ComplaintsBarChart extends StatelessWidget {
  final List<BarChartItem> data;

  const ComplaintsBarChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: "Complaints by Category",
      subtitle: "Last 30 days",
      iconData: Icons.bar_chart,
      iconColor: Colors.blue.shade700,
      iconBackgroundColor: Colors.blue.shade100,
      gradientColors: [Colors.white, Colors.blue.shade50],
      child: Column(
        children: [
          _buildLegend(),
          const SizedBox(height: 16),
          _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem('Pending', Colors.red.shade600),
        const SizedBox(width: 20),
        _legendItem('Total', Colors.blue.shade600),
        const SizedBox(width: 20),
        _legendItem('Resolved', Colors.green.shade600),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    // Find the maximum value for the y-axis
    double maxY = data.fold(0.0, (max, item) => 
      item.totalComplaints > max ? item.totalComplaints.toDouble() : max);
    
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY * 1.2, // Add 20% padding to the top
          minY: 0,
          alignment: BarChartAlignment.spaceAround,
          barGroups: data.asMap().entries.map((entry) {
            return _barGroup(entry.key, entry.value);
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        data[value.toInt()].category,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: maxY / 5, // Divide the axis into 5 parts
                getTitlesWidget: (value, _) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5, // Match the interval of left titles
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          backgroundColor: Colors.transparent,
          groupsSpace: 12, // Space between category groups
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, BarChartItem item) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4, // Space between bars in the group
      barRods: [
        // Pending bar (left)
        BarChartRodData(
          toY: item.pendingComplaints,
          width: 16,
          color: item.pendingColor,
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              item.pendingColor,
              item.pendingColor.withAlpha(178),
            ],
          ),
        ),
        // Total bar (center)
        BarChartRodData(
          toY: item.totalComplaints,
          width: 16,
          color: item.totalColor,
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              item.totalColor,
              item.totalColor.withAlpha(178),
            ],
          ),
        ),
        // Resolved bar (right)
        BarChartRodData(
          toY: item.resolvedComplaints,
          width: 16,
          color: item.resolvedColor,
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              item.resolvedColor,
              item.resolvedColor.withAlpha(178),
            ],
          ),
        ),
      ],
    );
  }
}