import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/customer.dart';
import '../../services/storage_service.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

// Import widgets
import 'widgets/customer_profile_header.dart';
import 'widgets/loan_list_item.dart';

// Import dialogs
import 'dialogs/edit_customer_dialog.dart';
import 'dialogs/delete_customer_dialog.dart';
import 'dialogs/add_loan_dialog.dart';

// Import loan screen
import '../loan/loan_detail_screen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final customer = storage.getCustomerById(customerId);
    final loans = storage.getLoansForCustomer(customerId);
    final currencyFormat = NumberFormat.currency(
      symbol: 'MMK ',
      decimalDigits: 0,
    );

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: Text('customer.title'.tr())),
        body: Center(child: Text('customer.not_found'.tr())),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header with Back button, Edit, Delete
            _buildHeader(context, isDark, customer, storage),
            const SizedBox(height: 16),
            // Fixed Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomerProfileHeader(customer: customer),
            ),
            const SizedBox(height: 16),
            // Loans header with Add button
            _buildLoansHeader(context, isDark, storage, loans.length),
            const SizedBox(height: 12),
            // Scrollable Loans List
            Expanded(
              child: _buildLoansList(
                context,
                isDark,
                storage,
                loans,
                currencyFormat,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Customer customer,
    StorageService storage,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => showEditCustomerDialog(context, customer, storage),
            icon: Icon(
              Icons.edit_rounded,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          IconButton(
            onPressed: () =>
                showDeleteCustomerConfirmation(context, storage, customerId),
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoansHeader(
    BuildContext context,
    bool isDark,
    StorageService storage,
    int loanCount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'customer.loans'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            ),
          ),
          Row(
            children: [
              Text(
                '$loanCount',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: AppTheme.primaryDark,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => showAddLoanDialog(context, storage, customerId),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'actions.add'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoansList(
    BuildContext context,
    bool isDark,
    StorageService storage,
    List loans,
    NumberFormat currencyFormat,
  ) {
    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: isDark ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'customer.no_loans'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'customer.add_loan_hint'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        final paid = storage.getTotalPaidForLoan(loan.id);
        final remaining = loan.totalAmount - paid;
        final progress = loan.totalAmount > 0 ? paid / loan.totalAmount : 0.0;

        return LoanListItem(
          loan: loan,
          paid: paid,
          remaining: remaining,
          progress: progress,
          isDark: isDark,
          currencyFormat: currencyFormat,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoanDetailScreen(loanId: loan.id),
              ),
            );
          },
        );
      },
    );
  }
}
