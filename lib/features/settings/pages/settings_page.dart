import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/language_controller.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageControllerProvider);
    final languageController = ref.read(languageControllerProvider.notifier);

    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      appBar: ProfessionalAppBar(
        title: 'SETTINGS',
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: true,
        notificationBadgeCount: 3, // Mock count
        onMenuPressed: () => _showHamburgerMenu(context),
        onNotificationPressed: () => context.go('/al/center'),
        actions: [
          AppBarActionButton(
            icon: Icons.search,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search - Coming Soon')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            UserProfileWidget(
              userName: '김토스',
              userEmail: 'kim.toss@dyinnovate.com',
              onProfileTap: () => _showUserProfile(context),
            ),

            const SizedBox(height: DesignTokens.spacingXl),

            // Language Section
            SettingsSection(
              title: 'LANGUAGE & REGION',
              children: [
                SettingsMenuItem(
                  icon: Icons.language,
                  title: 'English',
                  subtitle: 'English',
                  iconColor: currentLocale.languageCode == 'en'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'en'
                      ? Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'en', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: '한국어',
                  subtitle: 'Korean',
                  iconColor: currentLocale.languageCode == 'ko'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'ko'
                      ? Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'ko', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: '日本語',
                  subtitle: 'Japanese',
                  iconColor: currentLocale.languageCode == 'ja'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'ja'
                      ? Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'ja', context),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacingXl),

            // Account Section
            SettingsSection(
              title: 'ACCOUNT',
              children: [
                SettingsMenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile Settings',
                  subtitle: 'Manage your personal information',
                  onTap: () => _showProfileSettings(context),
                ),
                SettingsMenuItem(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: 'Password, 2FA, and security settings',
                  onTap: () => _showSecuritySettings(context),
                ),
                SettingsMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy',
                  subtitle: 'Data usage and privacy controls',
                  onTap: () => _showPrivacySettings(context),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacingXl),

            // App Settings Section
            SettingsSection(
              title: 'APP SETTINGS',
              children: [
                SettingsMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Push notifications and alerts',
                  onTap: () => _showNotificationSettings(context),
                ),
                SettingsMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  subtitle: 'Dark mode (always on)',
                  trailing: Icon(Icons.check_circle,
                      color: DesignTokens.statusActive,
                      size: DesignTokens.iconMd),
                  onTap: () => _showThemeSettings(context),
                ),
                SettingsMenuItem(
                  icon: Icons.storage,
                  title: 'Storage',
                  subtitle: 'Cache and data management',
                  onTap: () => _showStorageSettings(context),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacingXl),

            // Support Section
            SettingsSection(
              title: 'SUPPORT',
              children: [
                SettingsMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & FAQ',
                  subtitle: 'Get help and find answers',
                  onTap: () => _showHelp(context),
                ),
                SettingsMenuItem(
                  icon: Icons.bug_report,
                  title: 'Report Issue',
                  subtitle: 'Report bugs or problems',
                  onTap: () => _reportIssue(context),
                ),
                SettingsMenuItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () => _showAbout(context),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: DesignTokens.spacingXl),

            // Sign Out Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd),
              child: ActionButton(
                text: 'Sign Out',
                type: ActionButtonType.destructive,
                onPressed: () => _showSignOutDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(LanguageController controller, String languageCode,
      BuildContext context) {
    controller.setLanguageByCode(languageCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Language changed to ${controller.currentLanguageName}'),
        backgroundColor: DesignTokens.statusActive,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showHamburgerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const HamburgerMenu(),
    );
  }

  void _showUserProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User Profile - Coming Soon')),
    );
  }

  void _showProfileSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile Settings - Coming Soon')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security Settings - Coming Soon')),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Settings - Coming Soon')),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification Settings - Coming Soon')),
    );
  }

  void _showThemeSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme Settings - Coming Soon')),
    );
  }

  void _showStorageSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Storage Settings - Coming Soon')),
    );
  }

  void _showHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help & FAQ - Coming Soon')),
    );
  }

  void _reportIssue(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report Issue - Coming Soon')),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        title: Text(
          'About AproFleet Manager',
          style: TextStyle(color: DesignTokens.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0',
                style: TextStyle(color: DesignTokens.textSecondary)),
            const SizedBox(height: DesignTokens.spacingSm),
            Text('Manufacturer: DY Innovate',
                style: TextStyle(color: DesignTokens.textSecondary)),
            const SizedBox(height: DesignTokens.spacingSm),
            Text('Product: APRO Golf Cart',
                style: TextStyle(color: DesignTokens.textSecondary)),
            const SizedBox(height: DesignTokens.spacingSm),
            Text('© 2024 DY Innovate. All rights reserved.',
                style: TextStyle(color: DesignTokens.textTertiary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('OK', style: TextStyle(color: DesignTokens.statusActive)),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        title: Text(
          'Sign Out',
          style: TextStyle(color: DesignTokens.textPrimary),
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: DesignTokens.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: DesignTokens.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: Text('Sign Out',
                style: TextStyle(color: DesignTokens.statusCritical)),
          ),
        ],
      ),
    );
  }
}
