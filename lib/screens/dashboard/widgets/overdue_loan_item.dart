import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/loan.dart';
import '../../../services/storage_service.dart';
import '../../../theme/app_theme.dart';

/// Widget for displaying overdue loan items in dashboard
class OverdueLoanItem extends StatelessWidget {
  final Loan loan;
  final StorageService storage;
  final bool isDark;
  final NumberFormat currencyFormat;
  final int animationIndex;

  const OverdueLoanItem({
    super.key,
    required this.loan,
    required this.storage,
    required this.isDark,
    required this.currencyFormat,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final customer = storage.getCustomerById(loan.customerId);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (animationIndex * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: AppTheme.warningColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer?.name ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Due: ${DateFormat('MMM d, y').format(loan.dueDate)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormat.format(
                  loan.totalAmount - storage.getTotalPaidForLoan(loan.id),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
