import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Status Badge Component
///
/// Status indicators for golf cart states with:
/// - 5 status variants: active, idle, charging, maintenance, offline
/// - Optional pulse animation for active states
/// - Compact and expanded sizes
/// - Icon support
/// - Custom status text
///
/// Features:
/// - Animated pulse effect for real-time status
/// - Color-coded based on golf cart state
/// - No shadows (outline-based depth only)

enum ViaStatus {
  active,    // Green - Cart is active/moving
  idle,      // Orange - Cart is idle/waiting
  charging,  // Blue - Cart is charging
  maintenance, // Yellow/Orange - Cart under maintenance
  offline,   // Gray - Cart is offline/unavailable
}

enum ViaStatusBadgeSize {
  compact,   // Small badge with just dot and text
  expanded,  // Larger badge with icon, text, and optional description
}

class ViaStatusBadge extends StatefulWidget {
  final ViaStatus status;
  final ViaStatusBadgeSize size;
  final String? customText;
  final String? description;
  final bool showPulse;
  final IconData? customIcon;

  const ViaStatusBadge({
    super.key,
    required this.status,
    this.size = ViaStatusBadgeSize.compact,
    this.customText,
    this.description,
    this.showPulse = true,
    this.customIcon,
  });

  /// Active status badge - Green
  const ViaStatusBadge.active({
    super.key,
    this.size = ViaStatusBadgeSize.compact,
    this.customText,
    this.description,
    this.showPulse = true,
    this.customIcon,
  }) : status = ViaStatus.active;

  /// Idle status badge - Orange
  const ViaStatusBadge.idle({
    super.key,
    this.size = ViaStatusBadgeSize.compact,
    this.customText,
    this.description,
    this.showPulse = false,
    this.customIcon,
  }) : status = ViaStatus.idle;

  /// Charging status badge - Blue
  const ViaStatusBadge.charging({
    super.key,
    this.size = ViaStatusBadgeSize.compact,
    this.customText,
    this.description,
    this.showPulse = true,
    this.customIcon,
  }) : status = ViaStatus.charging;

  /// Maintenance status badge - Yellow/Orange
  const ViaStatusBadge.maintenance({
    super.key,
    this.size = ViaStatusBadgeSize.compact,
    this.customText,
    this.description,
    this.showPulse = false,
    this.customIcon,
  }) : status = ViaStatus.maintenance;

  /// Offline status badge - Gray
  const ViaStatusBadge.offline({
    super.key,
    this.size = ViaStatusBadgeSize.compact,
    this.customText,
    this.description,
    this.showPulse = false,
    this.customIcon,
  }) : status = ViaStatus.offline;

  @override
  State<ViaStatusBadge> createState() => _ViaStatusBadgeState();
}

class _ViaStatusBadgeState extends State<ViaStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.6,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ViaStatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showPulse && !oldWidget.showPulse) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.showPulse && oldWidget.showPulse) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case ViaStatus.active:
        return IndustrialDarkTokens.statusActive;
      case ViaStatus.idle:
        return IndustrialDarkTokens.statusIdle;
      case ViaStatus.charging:
        return IndustrialDarkTokens.statusCharging;
      case ViaStatus.maintenance:
        return IndustrialDarkTokens.statusMaintenance;
      case ViaStatus.offline:
        return IndustrialDarkTokens.statusOffline;
    }
  }

  IconData _getStatusIcon() {
    if (widget.customIcon != null) {
      return widget.customIcon!;
    }

    switch (widget.status) {
      case ViaStatus.active:
        return Icons.directions_run;
      case ViaStatus.idle:
        return Icons.pause_circle_outline;
      case ViaStatus.charging:
        return Icons.battery_charging_full;
      case ViaStatus.maintenance:
        return Icons.build_outlined;
      case ViaStatus.offline:
        return Icons.power_off;
    }
  }

  String _getStatusText() {
    if (widget.customText != null) {
      return widget.customText!;
    }

    switch (widget.status) {
      case ViaStatus.active:
        return 'Active';
      case ViaStatus.idle:
        return 'Idle';
      case ViaStatus.charging:
        return 'Charging';
      case ViaStatus.maintenance:
        return 'Maintenance';
      case ViaStatus.offline:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    if (widget.size == ViaStatusBadgeSize.compact) {
      return _buildCompactBadge(statusColor);
    } else {
      return _buildExpandedBadge(statusColor);
    }
  }

  Widget _buildCompactBadge(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: IndustrialDarkTokens.spacingCompact,
        vertical: IndustrialDarkTokens.spacingMinimal,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusChip),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: IndustrialDarkTokens.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dot with pulse
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              if (widget.showPulse)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 10.0 * _pulseAnimation.value,
                      height: 10.0 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withValues(
                          alpha: 0.3 * (1.0 - (_pulseAnimation.value - 1.0) / 0.6),
                        ),
                      ),
                    );
                  },
                ),
              // Status dot (NO boxShadow in Industrial Dark)
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  // NO boxShadow
                ),
              ),
            ],
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingCompact),
          // Status text
          Text(
            _getStatusText().toUpperCase(),
            style: IndustrialDarkTokens.labelStyle.copyWith(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: statusColor,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedBadge(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: IndustrialDarkTokens.spacingItem,
        vertical: IndustrialDarkTokens.spacingCompact,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: IndustrialDarkTokens.borderWidthThin,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with pulse background
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              if (widget.showPulse)
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 32.0 * _pulseAnimation.value,
                      height: 32.0 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withValues(
                          alpha: 0.2 * (1.0 - (_pulseAnimation.value - 1.0) / 0.6),
                        ),
                      ),
                    );
                  },
                ),
              // Icon container (NO boxShadow in Industrial Dark)
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(alpha: 0.2),
                  // NO boxShadow
                ),
                child: Icon(
                  _getStatusIcon(),
                  size: 20.0,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: IndustrialDarkTokens.spacingItem),
          // Text content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getStatusText(),
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  fontSize: IndustrialDarkTokens.fontSizeLabel,
                  color: statusColor,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                ),
              ),
              if (widget.description != null) ...[
                const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                Text(
                  widget.description!,
                  style: IndustrialDarkTokens.bodyStyle.copyWith(
                    fontSize: IndustrialDarkTokens.fontSizeSmall,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
