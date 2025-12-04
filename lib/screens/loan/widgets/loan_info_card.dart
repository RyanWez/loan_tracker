import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/customer.dart';
import '../../../models/loan.dart';
import 'loan_status_badge.dart';

/// The main loan info card showing total amount and status
class LoanInfoCard extends StatelessWidget {
  final Loan loan;
  final Customer? customer;
  final NumberFormat currencyFormat;

  const LoanInfoCard({
    super.key,
    required this.loan,
    this.customer,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            getStatusColor(loan.status),
            getStatusColor(loan.status).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: getStatusColor(loan.status).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          LoanStatusBadge(status: loan.status),
          const SizedBox(height: 16),
          Text(
            currencyFormat.format(loan.totalAmount),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          if (customer != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_rounded,
                  size: 16,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  customer!.name,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
