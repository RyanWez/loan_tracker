import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
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
          'loan.delete'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        content: Text(
          'loan.delete_warning'.tr(),
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
        'loan.delete_confirm'.tr(),
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
        ),
      ),
      content: Text(
        'loan.delete_warning'.tr(),
        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('actions.cancel'.tr()),
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
          child: Text('actions.delete'.tr()),
        ),
      ],
    ),
  );
}
