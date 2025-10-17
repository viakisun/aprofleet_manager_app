import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/design_tokens.dart';
import '../controllers/language_controller.dart';

/// Hamburger menu modal for professional navigation
class HamburgerMenu extends ConsumerWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageControllerProvider);
    final languageController = ref.read(languageControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.bgPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusLg),
        ),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin:
                const EdgeInsets.symmetric(vertical: DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: DesignTokens.borderSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // User Profile Section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: DesignTokens.statusActive,
                  child: Text(
                    '김',
                    style: TextStyle(
                      color: DesignTokens.textPrimary,
                      fontSize: DesignTokens.fontSizeLg,
                      fontWeight: DesignTokens.fontWeightBold,
                    ),
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '김토스',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      Text(
                        'kim.toss@dyinnovate.com',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: DesignTokens.textTertiary,
                  size: DesignTokens.iconSm,
                ),
              ],
            ),
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Quick Actions
          _buildMenuSection(
            context,
            title: 'QUICK ACTIONS',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                subtitle: 'Go to main dashboard',
                onTap: () {
                  Navigator.pop(context);
                  context.go('/ar/dashboard');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.qr_code_scanner,
                title: 'Scan QR Code',
                subtitle: 'Scan cart QR code',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR Scanner - Coming Soon')),
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.refresh,
                title: 'Refresh Data',
                subtitle: 'Sync latest data',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data refreshed')),
                  );
                },
                showDivider: false,
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Settings Section
          _buildMenuSection(
            context,
            title: 'SETTINGS',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'App preferences and configuration',
                onTap: () {
                  Navigator.pop(context);
                  context.go('/settings');
                },
                showDivider: false,
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Language Section
          _buildMenuSection(
            context,
            title: 'LANGUAGE',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: 'English',
                subtitle: 'English',
                trailing: currentLocale.languageCode == 'en'
                    ? Icon(Icons.check_circle,
                        color: DesignTokens.statusActive,
                        size: DesignTokens.iconMd)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  languageController.setLanguageByCode('en');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: '한국어',
                subtitle: 'Korean',
                trailing: currentLocale.languageCode == 'ko'
                    ? Icon(Icons.check_circle,
                        color: DesignTokens.statusActive,
                        size: DesignTokens.iconMd)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  languageController.setLanguageByCode('ko');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: '日本語',
                subtitle: 'Japanese',
                trailing: currentLocale.languageCode == 'ja'
                    ? Icon(Icons.check_circle,
                        color: DesignTokens.statusActive,
                        size: DesignTokens.iconMd)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  languageController.setLanguageByCode('ja');
                },
                showDivider: false,
              ),
            ],
          ),

          const SizedBox(height: DesignTokens.spacingLg),

          // Sign Out Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showSignOutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignTokens.alertCritical,
                  foregroundColor: DesignTokens.textPrimary,
                  elevation: DesignTokens.elevationNone,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingLg,
                    vertical: DesignTokens.spacingMd,
                  ),
                ),
                child: Text(
                  'SIGN OUT',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightSemibold,
                    letterSpacing: DesignTokens.letterSpacingWide,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: DesignTokens.spacingXl),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
          child: Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: DesignTokens.textSecondary,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
        ),
        const SizedBox(height: DesignTokens.spacingSm),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: DesignTokens.textSecondary,
            size: DesignTokens.iconMd,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              fontWeight: DesignTokens.fontWeightMedium,
              color: DesignTokens.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSm,
              color: DesignTokens.textSecondary,
            ),
          ),
          trailing: trailing,
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingXs,
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: DesignTokens.borderPrimary,
            indent: DesignTokens.spacingXl,
            endIndent: DesignTokens.spacingMd,
          ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        title: Text(
          'Sign Out',
          style: TextStyle(
            color: DesignTokens.textPrimary,
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightSemibold,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
            color: DesignTokens.textSecondary,
            fontSize: DesignTokens.fontSizeMd,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: DesignTokens.textSecondary,
                fontSize: DesignTokens.fontSizeMd,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close hamburger menu
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.alertCritical,
              foregroundColor: DesignTokens.textPrimary,
            ),
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightSemibold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
