import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/loan.dart';
import '../../../services/storage_service.dart';
import '../../../providers/theme_provider.dart';
import '../../../theme/app_theme.dart';

/// Shows a confirmation dialog for deleting a customer
void showDeleteCustomerConfirmation(
  BuildContext context,
  StorageService storage,
  String customerId,
) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final isDark = themeProvider.isDarkMode;
  final loans = storage.getLoansForCustomer(customerId);
  final hasActiveLoans = loans.any((loan) => loan.status == LoanStatus.active);

  // Capture the parent navigator before showing dialog
  final parentNavigator = Navigator.of(context);

  if (hasActiveLoans) {
    // Show warning that customer has active loans
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cannot delete.',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        content: Text(
          'It cannot be deleted because there are still debts to be paid. It can be deleted after all debts are paid off.',
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: isDark ? AppTheme.darkCard : AppTheme.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Delete Customer?',
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
        ),
      ),
      content: Text(
        'This will also delete all loans and payments associated with this customer. This action cannot be undone.',
        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Close dialog first
            Navigator.pop(dialogContext);
            // Delete the customer
            await storage.deleteCustomer(customerId);
            // Navigate back to previous screen using parent navigator
            if (context.mounted) {
              parentNavigator.pop();
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
