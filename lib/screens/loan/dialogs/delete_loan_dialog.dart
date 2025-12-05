import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/loan.dart';
import '../../../services/storage_service.dart';
import '../../../providers/theme_provider.dart';
import '../../../theme/app_theme.dart';

/// Shows a confirmation dialog for deleting a loan
void showDeleteLoanConfirmation(
  BuildContext context,
  StorageService storage,
  Loan loan,
  String loanId,
) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final isDark = themeProvider.isDarkMode;

  // Capture the parent navigator before showing dialog
  final parentNavigator = Navigator.of(context);

  // Check if loan is not completed (has remaining balance)
  if (loan.status != LoanStatus.completed) {
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
          'It can only be deleted after the debt is repaid.',
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
        'Delete Loan?',
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
        ),
      ),
      content: Text(
        'This will also delete all payments for this loan. This action cannot be undone.',
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
            // Delete the loan
            await storage.deleteLoan(loanId);
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
