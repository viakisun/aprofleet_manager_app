import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/alert.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/localization/app_localizations.dart';

class AlertSummaryCards extends ConsumerWidget {
  final AsyncValue<List<Alert>> alertsAsync;

  const AlertSummaryCards({
    super.key,
    required this.alertsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    
    if (alertsAsync is AsyncData<List<Alert>>) {
      final data = alertsAsync as AsyncData<List<Alert>>;
      final stats = _calculateStats(data.value);
      return _buildSummaryCards(context, localizations, stats);
    } else if (alertsAsync is AsyncLoading<List<Alert>>) {
      return _buildLoadingState(context, localizations);
    } else if (alertsAsync is AsyncError<List<Alert>>) {
      final error = alertsAsync as AsyncError<List<Alert>>;
      return _buildErrorState(context, localizations, error.error);
    }
    
    return _buildLoadingState(context, localizations);
  }

  Widget _buildSummaryCards(BuildContext context, AppLocalizations localizations, Map<String, int> stats) {

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
                      DesignTokens.textPrimary.withValues(alpha: 0.1),
                      DesignTokens.textPrimary.withValues(alpha: 0.05),
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
                      DesignTokens.alertCritical.withValues(alpha: 0.2),
                      DesignTokens.alertCritical.withValues(alpha: 0.1),
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
                      DesignTokens.alertWarning.withValues(alpha: 0.2),
                      DesignTokens.alertWarning.withValues(alpha: 0.1),
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
                      DesignTokens.alertInfo.withValues(alpha: 0.2),
                      DesignTokens.alertInfo.withValues(alpha: 0.1),
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
                      DesignTokens.statusActive.withValues(alpha: 0.2),
                      DesignTokens.statusActive.withValues(alpha: 0.1),
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
                      DesignTokens.alertSuccess.withValues(alpha: 0.2),
                      DesignTokens.alertSuccess.withValues(alpha: 0.1),
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
          color: color.withValues(alpha: 0.3),
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
                  color: color.withValues(alpha: 0.2),
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
                      ? DesignTokens.alertWarning.withValues(alpha: 0.2)
                      : DesignTokens.alertSuccess.withValues(alpha: 0.2),
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
              color: color.withValues(alpha: 0.8),
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

  Widget _buildLoadingState(BuildContext context, AppLocalizations localizations) {
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
          const SizedBox(height: DesignTokens.spacingSm),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations localizations, Object error) {
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
          const SizedBox(height: DesignTokens.spacingSm),
          Center(
            child: Text(
              'Error loading alerts: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
