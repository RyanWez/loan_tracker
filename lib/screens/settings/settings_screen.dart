import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';

// Import widgets
import 'widgets/theme_option_tile.dart';
import 'widgets/currency_info_card.dart';
import 'widgets/settings_item_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 32),
              // Appearance Section
              _buildSectionTitle('APPEARANCE', isDark),
              const SizedBox(height: 16),
              Container(
                decoration: AppTheme.cardDecoration(isDark),
                child: Column(
                  children: [
                    ThemeOptionTile(
                      title: 'Dark Mode',
                      icon: Icons.dark_mode_rounded,
                      value: true,
                      themeProvider: themeProvider,
                      isDark: isDark,
                    ),
                    _buildDivider(isDark),
                    ThemeOptionTile(
                      title: 'Light Mode',
                      icon: Icons.light_mode_rounded,
                      value: false,
                      themeProvider: themeProvider,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Currency Section
              _buildSectionTitle('CURRENCY', isDark),
              const SizedBox(height: 16),
              CurrencyInfoCard(isDark: isDark),
              const SizedBox(height: 32),
              // Data Section
              _buildSectionTitle('DATA', isDark),
              const SizedBox(height: 16),
              Container(
                decoration: AppTheme.cardDecoration(isDark),
                child: Column(
                  children: [
                    SettingsItemTile(
                      title: 'Export Data',
                      subtitle: 'Export all data as JSON',
                      icon: Icons.download_rounded,
                      color: AppTheme.accentColor,
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Export feature coming soon'),
                          ),
                        );
                      },
                    ),
                    _buildDivider(isDark),
                    SettingsItemTile(
                      title: 'Import Data',
                      subtitle: 'Import data from backup',
                      icon: Icons.upload_rounded,
                      color: AppTheme.primaryDark,
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Import feature coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[500] : Colors.grey[600],
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.05),
    );
  }
}
