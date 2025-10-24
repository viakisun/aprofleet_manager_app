import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:aprofleet_manager/domain/models/cart_issue.dart';
import 'package:aprofleet_manager/core/localization/app_localizations.dart';
import 'package:intl/intl.dart';

/// Admin Cart Card - FLEET-quality manager-centric cart display
///
/// Features:
/// - FLEET typography standard (fontSize 14, w600, letterSpacing 0)
/// - Simplified collapsed state with minimal info
/// - Quick action menu via more button
/// - Expandable details on demand
class AdminCartCard extends StatefulWidget {
  final Cart cart;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;
  final VoidCallback? onService;
  final VoidCallback? onWorkOrder;

  const AdminCartCard({
    super.key,
    required this.cart,
    this.isSelected = false,
    this.onTap,
    this.onTrack,
    this.onService,
    this.onWorkOrder,
  });

  @override
  State<AdminCartCard> createState() => _AdminCartCardState();
}

class _AdminCartCardState extends State<AdminCartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  Color _getStatusColor() {
    switch (widget.cart.status) {
      case CartStatus.active:
        return const Color(0xFF00C97B); // Active green
      case CartStatus.idle:
        return const Color(0xFFD67500); // Orange
      case CartStatus.charging:
        return const Color(0xFF3B83CC); // Blue
      case CartStatus.maintenance:
        return const Color(0xFFD14B4B); // Red
      case CartStatus.offline:
        return const Color(0xFF666666); // Gray
    }
  }

  Color _getBatteryColor(double level) {
    if (level > 50) return const Color(0xFF00C97B); // Green
    if (level > 20) return const Color(0xFFD67500); // Orange
    return const Color(0xFFD14B4B); // Red
  }

  IconData _batteryIcon(double percent) {
    if (percent >= 95) return Icons.battery_full_rounded;
    if (percent >= 75) return Icons.battery_6_bar_rounded;
    if (percent >= 50) return Icons.battery_5_bar_rounded;
    if (percent >= 30) return Icons.battery_3_bar_rounded;
    if (percent > 10) return Icons.battery_2_bar_rounded;
    return Icons.battery_alert_rounded;
  }

  Color _getIssueSeverityColor(IssueSeverity severity) {
    switch (severity) {
      case IssueSeverity.critical:
        return const Color(0xFFD14B4B); // Red
      case IssueSeverity.warning:
        return const Color(0xFFD67500); // Orange
      case IssueSeverity.info:
        return const Color(0xFFD6C500); // Yellow
    }
  }

  bool _shouldGlow(Color statusColor) {
    return statusColor == const Color(0xFF00C97B) || // Active
        statusColor == const Color(0xFF3B83CC); // Charging
  }

  CartIssue? _getCriticalIssue() {
    return widget.cart.activeIssues
        .where((issue) => issue.severity == IssueSeverity.critical)
        .isNotEmpty
        ? widget.cart.activeIssues
            .where((issue) => issue.severity == IssueSeverity.critical)
            .first
        : null;
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.cart.id,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFF1E1E1E)),

              // Actions
              _buildMenuAction(
                icon: Icons.my_location_rounded,
                label: 'VIEW ON MAP',
                onTap: () {
                  Navigator.pop(context);
                  widget.onTrack?.call();
                },
              ),
              _buildMenuAction(
                icon: Icons.assignment_rounded,
                label: 'CREATE WORK ORDER',
                onTap: () {
                  Navigator.pop(context);
                  widget.onWorkOrder?.call();
                },
              ),
              _buildMenuAction(
                icon: Icons.build_rounded,
                label: 'SERVICE OPTIONS',
                onTap: () {
                  Navigator.pop(context);
                  widget.onService?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.8)),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final batteryLevel = widget.cart.batteryLevel ?? 0;
    final batteryColor = _getBatteryColor(batteryLevel);
    final criticalIssue = _getCriticalIssue();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: IndustrialDarkTokens.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? IndustrialDarkTokens.accentPrimary.withOpacity(0.5)
                  : IndustrialDarkTokens.outline,
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Main Collapsed Content
              // Primary Row: Status + ID + Battery + More
              Row(
                children: [
                        // Status indicator with glow
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            boxShadow: _shouldGlow(statusColor)
                                ? [
                                    BoxShadow(
                                      color: statusColor.withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Cart ID - FLEET typography
                        Expanded(
                          child: Text(
                            widget.cart.id,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                              letterSpacing: 0,
                              height: 1.3,
                            ),
                          ),
                        ),

                        // Battery Indicator - FLEET style
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _batteryIcon(batteryLevel),
                              size: 16,
                              color: batteryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${batteryLevel.toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: batteryColor,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        // More menu button
                        InkWell(
                          onTap: () => _showActionMenu(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.more_vert,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),

              // Critical Issue Badge (if any)
              if (criticalIssue != null && !_isExpanded) ...[
                const SizedBox(height: 8),
                _buildCriticalIssueBadge(criticalIssue),
              ],

              // Expanded Details Section
              if (_isExpanded) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Details content
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status & Location
                          Row(
                              children: [
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: statusColor.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    widget.cart.status.displayName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                      letterSpacing: 0.3,
                                      height: 1.3,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Course location
                                if (widget.cart.courseLocation != null)
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          size: 12,
                                          color:
                                              Colors.white.withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            widget.cart.courseLocation!,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white
                                                  .withValues(alpha: 0.7),
                                              height: 1.3,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                          // All Issues
                          if (widget.cart.activeIssues.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'ISSUES (${widget.cart.activeIssuesCount})',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  letterSpacing: 0.5,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...widget.cart.activeIssues
                                  .map((issue) => _buildIssueRow(issue)),
                          ],

                          // Metrics Grid
                          const SizedBox(height: 12),
                          Row(
                              children: [
                                if (widget.cart.todayDistance != null)
                                  Expanded(
                                    child: _buildMetricItem(
                                      icon: Icons.route_rounded,
                                      label: 'TODAY',
                                      value:
                                          '${widget.cart.todayDistance!.toStringAsFixed(1)}km',
                                    ),
                                  ),
                                if (widget.cart.firmwareVersion != null)
                                  Expanded(
                                    child: _buildMetricItem(
                                      icon: Icons.memory_rounded,
                                      label: 'FIRMWARE',
                                      value: widget.cart.firmwareVersion!,
                                      warning:
                                          widget.cart.firmwareUpdateAvailable,
                                    ),
                                  ),
                                if (widget.cart.odometer != null)
                                  Expanded(
                                    child: _buildMetricItem(
                                      icon: Icons.speed_rounded,
                                      label: 'ODO',
                                      value:
                                          '${(widget.cart.odometer! / 1000).toStringAsFixed(0)}k km',
                                    ),
                                  ),
                              ],
                            ),

                          // Maintenance Dates
                          if (widget.cart.lastMaintenanceDate != null ||
                              widget.cart.nextMaintenanceDate != null) ...[
                              const SizedBox(height: 12),
                              if (widget.cart.nextMaintenanceDate != null)
                                _buildInfoRow(
                                  icon: Icons.event_rounded,
                                  label: 'NEXT SERVICE',
                                  value: DateFormat('MMM d, y')
                                      .format(widget.cart.nextMaintenanceDate!),
                                  warning: widget.cart.nextMaintenanceDate!
                                      .isBefore(DateTime.now()),
                                ),
                              if (widget.cart.lastMaintenanceDate != null) ...[
                                const SizedBox(height: 6),
                                _buildInfoRow(
                                  icon: Icons.build_circle_outlined,
                                  label: 'LAST SERVICE',
                                  value: DateFormat('MMM d, y')
                                      .format(widget.cart.lastMaintenanceDate!),
                                ),
                              ],
                          ],

                          // Primary Actions
                          const SizedBox(height: 12),
                          _buildPrimaryAction(
                              icon: Icons.assignment_rounded,
                              label: 'CREATE WORK ORDER',
                              onTap: widget.onWorkOrder,
                            ),
                          const SizedBox(height: 8),
                          _buildPrimaryAction(
                            icon: Icons.my_location_rounded,
                            label: 'VIEW ON MAP',
                            onTap: widget.onTrack,
                            secondary: true,
                          ),
                        ],
                      ),

                      // Collapse indicator
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Center(
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 20,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else
                // Expand indicator (collapsed state)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCriticalIssueBadge(CartIssue issue) {
    final color = _getIssueSeverityColor(issue.severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            issue.severity.emoji,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              issue.message,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueRow(CartIssue issue) {
    final color = _getIssueSeverityColor(issue.severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue.severity.emoji,
            style: const TextStyle(fontSize: 11),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.message,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  issue.actionType,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    bool warning = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: warning
              ? const Color(0xFFD67500)
              : Colors.white.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.4),
                  letterSpacing: 0.3,
                  height: 1.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: warning ? const Color(0xFFD67500) : Colors.white,
                  height: 1.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool warning = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: warning
              ? const Color(0xFFD67500)
              : Colors.white.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.5),
            letterSpacing: 0.3,
            height: 1.3,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: warning ? const Color(0xFFD67500) : Colors.white,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryAction({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool secondary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: secondary
              ? Colors.white.withValues(alpha: 0.05)
              : const Color(0xFF00C97B).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: secondary
                ? Colors.white.withValues(alpha: 0.1)
                : const Color(0xFF00C97B).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: secondary
                  ? Colors.white.withValues(alpha: 0.8)
                  : const Color(0xFF00C97B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondary
                    ? Colors.white.withValues(alpha: 0.8)
                    : const Color(0xFF00C97B),
                letterSpacing: 0.3,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
