import 'package:flutter/material.dart';
import '../../../core/widgets/via/via_bottom_sheet.dart';
import '../../../core/widgets/via/via_button.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

class AlertRulesPanel extends StatelessWidget {
  final VoidCallback onExportAlerts;
  final VoidCallback onClearResolved;

  const AlertRulesPanel({
    super.key,
    required this.onExportAlerts,
    required this.onClearResolved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'ALERT SETTINGS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(color: Colors.grey),

          // Settings options
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSettingItem(
                  icon: Icons.rule,
                  title: 'Alert Rules',
                  subtitle: 'Configure thresholds and notifications',
                  onTap: () => _showAlertRules(context),
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () => _showNotificationSettings(context),
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  icon: Icons.trending_up,
                  title: 'Escalation Matrix',
                  subtitle: 'View escalation policies',
                  onTap: () => _showEscalationMatrix(context),
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  icon: Icons.download,
                  title: 'Export Alerts',
                  subtitle: 'Download alert data as CSV',
                  onTap: onExportAlerts,
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  icon: Icons.clear_all,
                  title: 'Clear Resolved',
                  subtitle: 'Remove all resolved alerts',
                  onTap: () => _showClearResolvedDialog(context),
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertRules(BuildContext context) {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: const Text(
        'Alert Rules',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Text(
        'Alert rules configuration will be available in the full version.',
        style: TextStyle(color: IndustrialDarkTokens.textSecondary),
      ),
      footer: ViaButton.primary(
        text: 'OK',
        onPressed: () => Navigator.of(context).pop(),
        isFullWidth: true,
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: const Text(
        'Notification Settings',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Text(
        'Notification settings will be available in the full version.',
        style: TextStyle(color: IndustrialDarkTokens.textSecondary),
      ),
      footer: ViaButton.primary(
        text: 'OK',
        onPressed: () => Navigator.of(context).pop(),
        isFullWidth: true,
      ),
    );
  }

  void _showEscalationMatrix(BuildContext context) {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: const Text(
        'Escalation Matrix',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Text(
        'Escalation matrix will be available in the full version.',
        style: TextStyle(color: IndustrialDarkTokens.textSecondary),
      ),
      footer: ViaButton.primary(
        text: 'OK',
        onPressed: () => Navigator.of(context).pop(),
        isFullWidth: true,
      ),
    );
  }

  void _showClearResolvedDialog(BuildContext context) {
    ViaBottomSheet.show(
      context: context,
      snapPoints: [0.3, 0.5],
      header: const Text(
        'Clear Resolved Alerts',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: IndustrialDarkTokens.textPrimary,
        ),
      ),
      child: Text(
        'This will permanently remove all resolved alerts. This action cannot be undone.',
        style: TextStyle(color: IndustrialDarkTokens.textSecondary),
      ),
      footer: Row(
        children: [
          Expanded(
            child: ViaButton.ghost(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingItem),
          Expanded(
            child: ViaButton.danger(
              text: 'Clear',
              onPressed: () {
                Navigator.of(context).pop();
                onClearResolved();
              },
            ),
          ),
        ],
      ),
    );
  }
}
