import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/settings_widgets.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/services/map/map_provider_type.dart';
import '../../../core/services/map/map_settings_service.dart';
import '../../../core/widgets/via/via_toast.dart';
import '../../../core/widgets/via/via_bottom_sheet.dart';
import '../../../core/widgets/via/via_button.dart';
import '../widgets/scenario_control_panel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(languageControllerProvider);
    final languageController = ref.read(languageControllerProvider.notifier);
    final currentMapProvider = ref.watch(currentMapProviderProvider);

    return Scaffold(
      backgroundColor: IndustrialDarkTokens.bgBase,
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
              ViaToast.show(
                context: context,
                message: '${localizations.search} - ${localizations.comingSoon}',
                variant: ViaToastVariant.info,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            UserProfileWidget(
              userName: '김토스',
              userEmail: 'kim.toss@dyinnovate.com',
              onProfileTap: () => _showUserProfile(context),
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

            // Language Section
            SettingsSection(
              title: localizations.languageAndRegion,
              children: [
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.english,
                  subtitle: localizations.english,
                  iconColor: currentLocale.languageCode == 'en'
                      ? IndustrialDarkTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'en'
                      ? const Icon(Icons.check_circle,
                          color: IndustrialDarkTokens.statusActive,
                          size: 20)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'en', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.korean,
                  subtitle: localizations.korean,
                  iconColor: currentLocale.languageCode == 'ko'
                      ? IndustrialDarkTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'ko'
                      ? const Icon(Icons.check_circle,
                          color: IndustrialDarkTokens.statusActive,
                          size: 20)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'ko', context),
                ),
                SettingsMenuItem(
                  icon: Icons.language,
                  title: localizations.japanese,
                  subtitle: localizations.japanese,
                  iconColor: currentLocale.languageCode == 'ja'
                      ? IndustrialDarkTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'ja'
                      ? const Icon(Icons.check_circle,
                          color: IndustrialDarkTokens.statusActive,
                          size: 20)
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
                      ? IndustrialDarkTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'zh' &&
                          currentLocale.countryCode == 'CN'
                      ? const Icon(Icons.check_circle,
                          color: IndustrialDarkTokens.statusActive,
                          size: 20)
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
                      ? IndustrialDarkTokens.statusActive
                      : null,
                  trailing: currentLocale.languageCode == 'zh' &&
                          currentLocale.countryCode == 'TW'
                      ? const Icon(Icons.check_circle,
                          color: IndustrialDarkTokens.statusActive,
                          size: 20)
                      : null,
                  onTap: () =>
                      _changeLanguage(languageController, 'zh_TW', context),
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

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

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

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
                      color: IndustrialDarkTokens.statusActive,
                      size: 20),
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

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

            // Simulation Section
            SettingsSection(
              title: 'SIMULATION & DEMO',
              children: const [
                ScenarioControlPanel(),
              ],
            ),

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

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

            const SizedBox(height: IndustrialDarkTokens.spacingSection),

            // Sign Out Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                  horizontal: IndustrialDarkTokens.spacingItem),
              child: ViaButton.danger(
                text: localizations.signOut,
                onPressed: () => _showSignOutDialog(context),
                isFullWidth: true,
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

    ViaToast.show(
      context: context,
      message: '${localizations.languageChanged} ${controller.currentLanguageName}',
      variant: ViaToastVariant.success,
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
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.5, 0.8],
      header: const Text(
        'Select Map Provider',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: MapProviderType.values.map((provider) {
          return ListTile(
            leading: Icon(
              provider.icon,
              color: IndustrialDarkTokens.textPrimary,
            ),
            title: Text(
              provider.name,
              style: TextStyle(color: IndustrialDarkTokens.textPrimary),
            ),
            subtitle: Text(
              provider.description,
              style: TextStyle(color: IndustrialDarkTokens.textSecondary),
            ),
            onTap: () async {
              Navigator.pop(context);
              final service = ref.read(mapSettingsServiceProvider);
              await service.setSelectedProvider(provider);

              if (context.mounted) {
                ViaToast.show(
                  context: context,
                  message: 'Map provider changed to ${provider.name}',
                  variant: ViaToastVariant.success,
                );
              }
            },
          );
        }).toList(),
      ),
      footer: ViaButton.ghost(
        text: 'Cancel',
        onPressed: () => Navigator.pop(context),
        isFullWidth: true,
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.profileSettings} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showProfileSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.profileSettings} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showSecuritySettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.security} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showPrivacySettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.privacy} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showNotificationSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.notifications} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showThemeSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.theme} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showStorageSettings(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.storage} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showHelp(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.helpFaq} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _reportIssue(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaToast.show(
      context: context,
      message: '${localizations.reportIssue} - ${localizations.comingSoon}',
      variant: ViaToastVariant.info,
    );
  }

  void _showAbout(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.4, 0.7],
      header: Text(
        localizations.aboutAproFleetManager,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.versionInfo,
              style: TextStyle(color: IndustrialDarkTokens.textSecondary)),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          Text(localizations.manufacturerInfo,
              style: TextStyle(color: IndustrialDarkTokens.textSecondary)),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          Text(localizations.productInfo,
              style: TextStyle(color: IndustrialDarkTokens.textSecondary)),
          const SizedBox(height: IndustrialDarkTokens.spacingCompact),
          Text('© 2024 DY Innovate. All rights reserved.',
              style: TextStyle(color: IndustrialDarkTokens.textSecondary)),
        ],
      ),
      footer: ViaButton.primary(
        text: localizations.ok,
        onPressed: () => Navigator.pop(context),
        isFullWidth: true,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: Text(
        localizations.signOut,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Text(
        localizations.signOutConfirm,
        style: TextStyle(color: IndustrialDarkTokens.textSecondary),
      ),
      footer: Row(
        children: [
          Expanded(
            child: ViaButton.ghost(
              text: localizations.cancel,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingItem),
          Expanded(
            child: ViaButton.danger(
              text: localizations.signOut,
              onPressed: () {
                Navigator.pop(context);
                ViaToast.show(
                  context: context,
                  message: localizations.signedOutSuccess,
                  variant: ViaToastVariant.success,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
