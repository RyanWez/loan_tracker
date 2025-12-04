import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/animated_circular_chart.dart';
import 'chart_legend.dart';

/// Widget for displaying the loan overview card with circular chart
class LoanOverviewCard extends StatelessWidget {
  final double totalDebt;
  final double totalPaid;
  final String outstandingFormatted;
  final String paidFormatted;

  const LoanOverviewCard({
    super.key,
    required this.totalDebt,
    required this.totalPaid,
    required this.outstandingFormatted,
    required this.paidFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryDark, Color(0xFF8B83FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Loan Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Circular Chart
          AnimatedCircularChart(
            totalDebt: totalDebt - totalPaid, // Outstanding
            totalPaid: totalPaid,
            isDark: true, // Always light text on gradient
          ),
          const SizedBox(height: 24),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChartLegend(
                label: 'Outstanding',
                value: outstandingFormatted,
                color: const Color(0xFFFF6B6B),
              ),
              ChartLegend(
                label: 'Repaid',
                value: paidFormatted,
                color: const Color(0xFF00E676),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
