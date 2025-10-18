import 'package:flutter/material.dart';
import '../../../domain/models/alert.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/localization/app_localizations.dart';

class AlertSummaryCards extends StatelessWidget {
  final List<Alert> alerts;

  const AlertSummaryCards({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final stats = _calculateStats(alerts);

    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.alertSummary,
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: DesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: localizations.totalAlerts,
                  count: stats['total'] ?? 0,
                  icon: Icons.notifications,
                  color: DesignTokens.textPrimary,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.textPrimary.withOpacity(0.1),
                      DesignTokens.textPrimary.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: _buildSummaryCard(
                  title: localizations.critical,
                  count: stats['critical'] ?? 0,
                  icon: Icons.priority_high,
                  color: DesignTokens.alertCritical,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.alertCritical.withOpacity(0.2),
                      DesignTokens.alertCritical.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: localizations.warning,
                  count: stats['warning'] ?? 0,
                  icon: Icons.warning,
                  color: DesignTokens.alertWarning,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.alertWarning.withOpacity(0.2),
                      DesignTokens.alertWarning.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: _buildSummaryCard(
                  title: localizations.info,
                  count: stats['info'] ?? 0,
                  icon: Icons.info,
                  color: DesignTokens.alertInfo,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.alertInfo.withOpacity(0.2),
                      DesignTokens.alertInfo.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          // Active vs Resolved
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: localizations.active,
                  count: stats['active'] ?? 0,
                  icon: Icons.visibility,
                  color: DesignTokens.statusActive,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.statusActive.withOpacity(0.2),
                      DesignTokens.statusActive.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: _buildSummaryCard(
                  title: localizations.resolved,
                  count: stats['resolved'] ?? 0,
                  icon: Icons.check_circle,
                  color: DesignTokens.alertSuccess,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.alertSuccess.withOpacity(0.2),
                      DesignTokens.alertSuccess.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignTokens.spacingSm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(
                  icon,
                  size: DesignTokens.iconMd,
                  color: color,
                ),
              ),
              const Spacer(),
              // Trend indicator (mock)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingXs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: count > 0
                      ? DesignTokens.alertWarning.withOpacity(0.2)
                      : DesignTokens.alertSuccess.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      count > 0 ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: count > 0
                          ? DesignTokens.alertWarning
                          : DesignTokens.alertSuccess,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      count > 0 ? '+12%' : '-5%',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXs,
                        fontWeight: DesignTokens.fontWeightSemibold,
                        color: count > 0
                            ? DesignTokens.alertWarning
                            : DesignTokens.alertSuccess,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacingMd),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: DesignTokens.fontSize2xl,
              fontWeight: DesignTokens.fontWeightBold,
              color: color,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            title,
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize: DesignTokens.fontSizeXs,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats(List<Alert> alerts) {
    final stats = <String, int>{
      'total': alerts.length,
      'critical': 0,
      'warning': 0,
      'info': 0,
      'active': 0,
      'resolved': 0,
    };

    for (final alert in alerts) {
      // Count by severity
      switch (alert.severity) {
        case AlertSeverity.critical:
          stats['critical'] = (stats['critical'] ?? 0) + 1;
          break;
        case AlertSeverity.warning:
          stats['warning'] = (stats['warning'] ?? 0) + 1;
          break;
        case AlertSeverity.info:
          stats['info'] = (stats['info'] ?? 0) + 1;
          break;
        case AlertSeverity.success:
          stats['info'] = (stats['info'] ?? 0) + 1; // Count success as info
          break;
      }

      // Count by state
      switch (alert.state) {
        case AlertStatus.triggered:
        case AlertStatus.notified:
        case AlertStatus.acknowledged:
        case AlertStatus.escalated:
          stats['active'] = (stats['active'] ?? 0) + 1;
          break;
        case AlertStatus.resolved:
          stats['resolved'] = (stats['resolved'] ?? 0) + 1;
          break;
      }
    }

    return stats;
  }
}
