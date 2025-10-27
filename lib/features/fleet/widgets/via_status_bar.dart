import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';

/// VIA Design System Status Bar for Cart Filtering
///
/// Displays status chips with counts and filter functionality
class ViaStatusBar extends StatelessWidget {
  final Map<CartStatus, int> statusCounts;
  final Set<CartStatus> activeFilters;
  final Function(CartStatus) onFilterTap;
  final VoidCallback? onOpenFilter;

  const ViaStatusBar({
    super.key,
    required this.statusCounts,
    required this.activeFilters,
    required this.onFilterTap,
    this.onOpenFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Increased from 40 for better touch targets
      padding: const EdgeInsets.symmetric(
        horizontal: IndustrialDarkTokens.spacingItem,
        vertical: IndustrialDarkTokens.spacingCompact,
      ),
      decoration: BoxDecoration(
        color: IndustrialDarkTokens.bgBase,
        border: Border(
          top: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Status filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: CartStatus.values.map((status) {
                  final count = statusCounts[status] ?? 0;
                  final isActive = activeFilters.contains(status);
                  final color = _getStatusColor(status);

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: IndustrialDarkTokens.spacingCompact,
                    ),
                    child: _StatusChip(
                      status: status,
                      count: count,
                      isActive: isActive,
                      color: color,
                      onTap: () => onFilterTap(status),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Filter button
          if (onOpenFilter != null) ...[
            const SizedBox(width: IndustrialDarkTokens.spacingCompact),
            GestureDetector(
              onTap: onOpenFilter,
              child: Tooltip(
                message: 'Filter',
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: IndustrialDarkTokens.bgSurface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: IndustrialDarkTokens.outline,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    size: 16,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return IndustrialDarkTokens.statusActive;
      case CartStatus.idle:
        return IndustrialDarkTokens.statusIdle;
      case CartStatus.charging:
        return IndustrialDarkTokens.statusCharging;
      case CartStatus.maintenance:
        return IndustrialDarkTokens.statusMaintenance;
      case CartStatus.offline:
        return IndustrialDarkTokens.statusOffline;
    }
  }
}

/// Status chip with count badge
class _StatusChip extends StatefulWidget {
  final CartStatus status;
  final int count;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.status,
    required this.count,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  @override
  State<_StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<_StatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: IndustrialDarkTokens.durationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: IndustrialDarkTokens.curveStandard,
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

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: IndustrialDarkTokens.durationFast,
          padding: const EdgeInsets.symmetric(
            horizontal: IndustrialDarkTokens.spacingCompact,
            vertical: IndustrialDarkTokens.spacingCompact,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.color.withValues(alpha: 0.15)
                : IndustrialDarkTokens.bgSurface,
            borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusChip),
            border: Border.all(
              color: widget.isActive
                  ? widget.color
                  : IndustrialDarkTokens.outline,
              width: widget.isActive ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status dot
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              // Status name
              Text(
                widget.status.displayName,
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  color: widget.isActive
                      ? widget.color
                      : IndustrialDarkTokens.textSecondary,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
              // Count badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: IndustrialDarkTokens.spacingCompact,
                ),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? widget.color.withValues(alpha: 0.2)
                      : IndustrialDarkTokens.bgBase,
                  borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                ),
                child: Text(
                  widget.count.toString(),
                  style: IndustrialDarkTokens.labelStyle.copyWith(
                    color: widget.isActive
                        ? widget.color
                        : IndustrialDarkTokens.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
