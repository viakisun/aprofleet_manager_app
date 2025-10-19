import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/services/map/map_provider_type.dart';
import '../../../core/services/map/map_settings_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageControllerProvider);
    final languageController = ref.read(languageControllerProvider.notifier);
    final currentMapProvider = ref.watch(currentMapProviderProvider);

    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      appBar: ProfessionalAppBar(
        title: localizations.settingsTitle,
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
                SnackBar(
                    content: Text(
                        '${localizations.search} - ${localizations.comingSoon}')),
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
              title: localizations.languageAndRegion,
              children: [
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.english,
                  subtitle: localizations.english,
                  iconColor: currentLocale.languageCode == 'en'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'en'
                      ? const Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'en', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.korean,
                  subtitle: localizations.korean,
                  iconColor: currentLocale.languageCode == 'ko'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'ko'
                      ? const Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'ko', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.japanese,
                  subtitle: localizations.japanese,
                  iconColor: currentLocale.languageCode == 'ja'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'ja'
                      ? const Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'ja', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.chineseSimplified,
                  subtitle: localizations.chineseSimplified,
                  iconColor: currentLocale.languageCode == 'zh' &&
                          currentLocale.countryCode == 'CN'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'zh' &&
                          currentLocale.countryCode == 'CN'
                      ? const Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'zh_CN', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.chineseTraditional,
                  subtitle: localizations.chineseTraditional,
                  iconColor: currentLocale.languageCode == 'zh' &&
                          currentLocale.countryCode == 'TW'
                      ? DesignTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'zh' &&
                          currentLocale.countryCode == 'TW'
                      ? const Icon(Icons.check_circle,
                          color: DesignTokens.statusActive,
                          size: DesignTokens.iconMd)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'zh_TW', context),
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
                  icon: Icons.map_outlined,
                  title: 'Map Provider',
                  subtitle: currentMapProvider.when(
                    data: (provider) => provider.name,
                    loading: () => 'Loading...',
                    error: (_, __) => 'Error',
                  ),
                  onTap: () => _showMapProviderDialog(context, ref),
                ),
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
                  trailing: const Icon(Icons.check_circle,
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
                text: localizations.signOut,
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
    final localizations = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${localizations.languageChanged} ${controller.currentLanguageName}'),
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

  void _showMapProviderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        title: const Text(
          'Select Map Provider',
          style: TextStyle(color: DesignTokens.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: MapProviderType.values.map((provider) {
            return ListTile(
              leading: Icon(
                provider.icon,
                color: DesignTokens.textPrimary,
              ),
              title: Text(
                provider.name,
                style: const TextStyle(color: DesignTokens.textPrimary),
              ),
              subtitle: Text(
                provider.description,
                style: TextStyle(color: DesignTokens.textSecondary),
              ),
              onTap: () async {
                Navigator.pop(context);
                final service = ref.read(mapSettingsServiceProvider);
                await service.setSelectedProvider(provider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Map provider changed to ${provider.name}'),
                      backgroundColor: DesignTokens.statusActive,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: DesignTokens.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${localizations.profileSettings} - ${localizations.comingSoon}')),
    );
  }

  void _showProfileSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${localizations.profileSettings} - ${localizations.comingSoon}')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('${localizations.security} - ${localizations.comingSoon}')),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('${localizations.privacy} - ${localizations.comingSoon}')),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${localizations.notifications} - ${localizations.comingSoon}')),
    );
  }

  void _showThemeSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('${localizations.theme} - ${localizations.comingSoon}')),
    );
  }

  void _showStorageSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('${localizations.storage} - ${localizations.comingSoon}')),
    );
  }

  void _showHelp(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('${localizations.helpFaq} - ${localizations.comingSoon}')),
    );
  }

  void _reportIssue(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              '${localizations.reportIssue} - ${localizations.comingSoon}')),
    );
  }

  void _showAbout(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        title: Text(
          localizations.aboutAproFleetManager,
          style: const TextStyle(color: DesignTokens.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.versionInfo,
                style: TextStyle(color: DesignTokens.textSecondary)),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(localizations.manufacturerInfo,
                style: TextStyle(color: DesignTokens.textSecondary)),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(localizations.productInfo,
                style: TextStyle(color: DesignTokens.textSecondary)),
            const SizedBox(height: DesignTokens.spacingSm),
            Text('© 2024 DY Innovate. All rights reserved.',
                style: TextStyle(color: DesignTokens.textTertiary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.ok,
                style: const TextStyle(color: DesignTokens.statusActive)),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignTokens.bgSecondary,
        title: Text(
          localizations.signOut,
          style: const TextStyle(color: DesignTokens.textPrimary),
        ),
        content: Text(
          localizations.signOutConfirm,
          style: TextStyle(color: DesignTokens.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel,
                style: TextStyle(color: DesignTokens.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizations.signedOutSuccess)),
              );
            },
            child: Text(localizations.signOut,
                style: const TextStyle(color: DesignTokens.statusCritical)),
          ),
        ],
      ),
    );
  }
}
