import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/design_tokens.dart';
import '../controllers/language_controller.dart';
import '../localization/app_localizations.dart';

/// Hamburger menu modal for professional navigation
class HamburgerMenu extends ConsumerWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageControllerProvider);
    final languageController = ref.read(languageControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.bgPrimary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(
              DesignTokens.radiusLg), // Already using updated radius
        ),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar - More subtle
          Container(
            width: 32, // Smaller handle
            height: 3, // Thinner handle
            margin: const EdgeInsets.symmetric(
                vertical: DesignTokens.spacingSm), // Tighter margin
            decoration: BoxDecoration(
              color: DesignTokens.borderPrimary, // More subtle color
              borderRadius: BorderRadius.circular(1), // Sharper corners
            ),
          ),

          // User Profile Section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
            child: Row(
              children: [
                const CircleAvatar(
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
                      const Text(
                        '김토스',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens
                              .fontWeightBold, // Bolder for hierarchy
                          color: DesignTokens.textPrimary,
                          letterSpacing: DesignTokens
                              .letterSpacingNormal, // Tighter tracking
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
            title: localizations.quickActions,
            items: [
              _buildMenuItem(
                context,
                icon: Icons.dashboard_outlined,
                title: localizations.dashboard,
                subtitle: localizations.dashboardSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  context.go('/ar/dashboard');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.qr_code_scanner,
                title: localizations.scanQrCode,
                subtitle: localizations.scanQrSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${localizations.scanQrCode} - ${localizations.comingSoon}')),
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.refresh,
                title: localizations.refreshData,
                subtitle: localizations.refreshDataSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.dataRefreshed)),
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
            title: localizations.menuSettings,
            items: [
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                title: localizations.menuSettingsTitle,
                subtitle: localizations.menuSettingsSubtitle,
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
            title: localizations.menuLanguage,
            items: [
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: localizations.menuEnglish,
                subtitle: localizations.menuEnglish,
                trailing: currentLocale.languageCode == 'en'
                    ? const Icon(Icons.check_circle,
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
                title: localizations.menuKorean,
                subtitle: localizations.menuKorean,
                trailing: currentLocale.languageCode == 'ko'
                    ? const Icon(Icons.check_circle,
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
                title: localizations.menuJapanese,
                subtitle: localizations.menuJapanese,
                trailing: currentLocale.languageCode == 'ja'
                    ? const Icon(Icons.check_circle,
                        color: DesignTokens.statusActive,
                        size: DesignTokens.iconMd)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  languageController.setLanguageByCode('ja');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: '简体中文',
                subtitle: localizations.menuChineseSimplified,
                trailing: currentLocale == const Locale('zh', 'CN')
                    ? const Icon(Icons.check_circle,
                        color: DesignTokens.statusActive,
                        size: DesignTokens.iconMd)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  languageController.setLanguageByCode('zh_CN');
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: '繁體中文',
                subtitle: localizations.menuChineseTraditional,
                trailing: currentLocale == const Locale('zh', 'TW')
                    ? const Icon(Icons.check_circle,
                        color: DesignTokens.statusActive,
                        size: DesignTokens.iconMd)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  languageController.setLanguageByCode('zh_TW');
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
                    borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMd), // Sharper corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingLg,
                    vertical: DesignTokens.spacingMd,
                  ),
                ),
                child: Text(
                  localizations.menuSignOut,
                  style: const TextStyle(
                    fontSize: DesignTokens.fontSizeMd,
                    fontWeight: DesignTokens.fontWeightBold, // Bolder text
                    letterSpacing:
                        DesignTokens.letterSpacingNormal, // Tighter tracking
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
              fontWeight: DesignTokens.fontWeightBold, // Bolder for hierarchy
              color: DesignTokens.textSecondary,
              letterSpacing:
                  DesignTokens.letterSpacingNormal, // Tighter tracking
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
            style: const TextStyle(
              fontSize: DesignTokens.fontSizeMd,
              fontWeight: DesignTokens.fontWeightBold, // Bolder for hierarchy
              color: DesignTokens.textPrimary,
              letterSpacing:
                  DesignTokens.letterSpacingNormal, // Tighter tracking
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
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        ),
        title: Text(
          localizations.menuSignOutTitle,
          style: const TextStyle(
            color: DesignTokens.textPrimary,
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightSemibold,
          ),
        ),
        content: Text(
          localizations.menuSignOutMessage,
          style: TextStyle(
            color: DesignTokens.textSecondary,
            fontSize: DesignTokens.fontSizeMd,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.cancel,
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
                SnackBar(content: Text(localizations.menuSignOutSuccess)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignTokens.alertCritical,
              foregroundColor: DesignTokens.textPrimary,
            ),
            child: Text(
              localizations.menuSignOut,
              style: const TextStyle(
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
