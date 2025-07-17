import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/widgets/dashBoardCardheader.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;
  final Color iconColor;
  final Color iconBackgroundColor;
  final List<Color> gradientColors;
  final Widget child;
  final Widget? actionButton;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.gradientColors,
    required this.child,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardCardHeader(
              title: title,
              subtitle: subtitle,
              iconData: iconData,
              iconColor: iconColor,
              iconBackgroundColor: iconBackgroundColor,
              actionButton: actionButton,
            ),
            const SizedBox(height: 24),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}