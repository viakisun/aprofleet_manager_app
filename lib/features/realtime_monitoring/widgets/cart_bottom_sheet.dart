import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/via_design_tokens.dart';
import '../../../domain/models/cart.dart';
import '../controllers/live_map_controller.dart';
import '../state/realtime_map_state.dart';
import 'via_cart_list_item.dart';

/// Persistent bottom sheet for cart list with 3 snap states:
/// - Peek (15%): KPI summary + selected cart
/// - Half (50%): Full cart list
/// - Full (95%): Cart list + filters/sort/actions
class CartBottomSheet extends ConsumerStatefulWidget {
  final List<Cart> carts;
  final String? selectedCartId;
  final Function(Cart) onCartSelected;

  const CartBottomSheet({
    super.key,
    required this.carts,
    required this.selectedCartId,
    required this.onCartSelected,
  });

  @override
  ConsumerState<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends ConsumerState<CartBottomSheet>
    with SingleTickerProviderStateMixin {
  static const double peekHeight = 0.15;
  static const double halfHeight = 0.5;
  static const double fullHeight = 0.95;

  int _currentSnapIndex = 0; // 0=Peek, 1=Half, 2=Full
  double _dragOffset = 0.0;
  double _screenHeight = 0.0;

  final List<double> _snapPoints = [peekHeight, halfHeight, fullHeight];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ViaDesignTokens.durationNormal,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: ViaDesignTokens.curveDeceleration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CartBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Auto-expand to Half when cart is selected
    if (widget.selectedCartId != null &&
        oldWidget.selectedCartId == null &&
        _currentSnapIndex == 0) {
      _snapToIndex(1); // Expand to Half
    }

    // Collapse to Peek when cart is deselected
    if (widget.selectedCartId == null &&
        oldWidget.selectedCartId != null &&
        _currentSnapIndex == 1) {
      _snapToIndex(0); // Collapse to Peek
    }
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset -= details.primaryDelta ?? 0;
      final maxDrag = _screenHeight * (_snapPoints.last - _snapPoints.first);
      _dragOffset = _dragOffset.clamp(0.0, maxDrag);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final currentHeight = _getCurrentHeight();
    final currentFraction = currentHeight / _screenHeight;

    // Find nearest snap point
    int targetSnapIndex = _currentSnapIndex;
    double minDistance = double.infinity;

    for (int i = 0; i < _snapPoints.length; i++) {
      final distance = (_snapPoints[i] - currentFraction).abs();
      if (distance < minDistance) {
        minDistance = distance;
        targetSnapIndex = i;
      }
    }

    // Adjust based on velocity (fast swipe)
    if (velocity < -500 && targetSnapIndex < _snapPoints.length - 1) {
      targetSnapIndex++; // Expand
    } else if (velocity > 500 && targetSnapIndex > 0) {
      targetSnapIndex--; // Collapse
    }

    _snapToIndex(targetSnapIndex);
  }

  void _snapToIndex(int index) {
    if (index == _currentSnapIndex && _dragOffset == 0) return;

    setState(() {
      _currentSnapIndex = index;
      _dragOffset = 0.0;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  double _getCurrentHeight() {
    final baseHeight = _screenHeight * _snapPoints[_currentSnapIndex];
    return baseHeight + _dragOffset;
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: _handleVerticalDragUpdate,
        onVerticalDragEnd: _handleVerticalDragEnd,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: _getCurrentHeight() * _animation.value,
              decoration: BoxDecoration(
                color: ViaDesignTokens.surfaceSecondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(ViaDesignTokens.radiusXl),
                  topRight: Radius.circular(ViaDesignTokens.radiusXl),
                ),
                border: Border(
                  top: BorderSide(
                    color: ViaDesignTokens.borderPrimary,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  _buildDragHandle(),

                  // Content based on snap state
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(
        top: ViaDesignTokens.spacingMd,
        bottom: ViaDesignTokens.spacingSm,
      ),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: ViaDesignTokens.textMuted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusFull),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentSnapIndex) {
      case 0:
        return _buildPeekContent();
      case 1:
        return _buildHalfContent();
      case 2:
        return _buildFullContent();
      default:
        return _buildPeekContent();
    }
  }

  // Peek state: KPI summary + selected cart
  Widget _buildPeekContent() {
    final statusCounts = _getStatusCounts();
    final selectedCart = widget.selectedCartId != null
        ? widget.carts.firstWhere(
            (c) => c.id == widget.selectedCartId,
            orElse: () => widget.carts.first,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ViaDesignTokens.spacingLg,
        vertical: ViaDesignTokens.spacingMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // KPI summary bar
          _buildKPISummary(statusCounts),

          const SizedBox(height: ViaDesignTokens.spacingMd),

          // Selected cart or hint
          if (selectedCart != null)
            _buildSelectedCartRow(selectedCart)
          else
            _buildSelectionHint(),
        ],
      ),
    );
  }

  Widget _buildKPISummary(Map<CartStatus, int> counts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildKPIItem(
          icon: Icons.circle,
          color: ViaDesignTokens.statusActive,
          label: 'Active',
          count: counts[CartStatus.active] ?? 0,
        ),
        _buildKPIItem(
          icon: Icons.circle,
          color: ViaDesignTokens.statusIdle,
          label: 'Idle',
          count: counts[CartStatus.idle] ?? 0,
        ),
        _buildKPIItem(
          icon: Icons.circle,
          color: ViaDesignTokens.statusCharging,
          label: 'Charging',
          count: counts[CartStatus.charging] ?? 0,
        ),
        _buildKPIItem(
          icon: Icons.circle,
          color: ViaDesignTokens.statusOffline,
          label: 'Offline',
          count: counts[CartStatus.offline] ?? 0,
        ),
      ],
    );
  }

  Widget _buildKPIItem({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ViaDesignTokens.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: ViaDesignTokens.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCartRow(Cart cart) {
    final batteryPct = cart.batteryPct?.toInt() ?? 0;
    final statusColor = _getCartStatusColor(cart.status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ViaDesignTokens.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        border: Border.all(
          color: ViaDesignTokens.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              cart.id,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ViaDesignTokens.textPrimary,
              ),
            ),
          ),
          Icon(
            _batteryIcon(batteryPct),
            size: 16,
            color: _getBatteryColor(batteryPct),
          ),
          const SizedBox(width: 4),
          Text(
            '$batteryPct%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getBatteryColor(batteryPct),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ViaDesignTokens.surfaceTertiary,
        borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        border: Border.all(color: ViaDesignTokens.borderPrimary),
      ),
      child: Row(
        children: [
          Icon(
            Icons.touch_app,
            size: 16,
            color: ViaDesignTokens.textMuted,
          ),
          const SizedBox(width: 8),
          Text(
            'Tap a cart on the map to view details',
            style: TextStyle(
              fontSize: 12,
              color: ViaDesignTokens.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // Half state: Full cart list
  Widget _buildHalfContent() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ViaDesignTokens.spacingLg,
            vertical: ViaDesignTokens.spacingMd,
          ),
          child: Row(
            children: [
              Icon(Icons.directions_car, size: 16, color: ViaDesignTokens.textPrimary),
              const SizedBox(width: 8),
              Text(
                'CARTS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ViaDesignTokens.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.carts.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ViaDesignTokens.textMuted,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.sort, size: 18, color: ViaDesignTokens.textSecondary),
                onPressed: () {
                  // TODO: Implement sort
                },
                tooltip: 'Sort',
              ),
            ],
          ),
        ),

        Divider(height: 1, color: ViaDesignTokens.borderPrimary),

        // Cart list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(ViaDesignTokens.spacingLg),
            itemCount: widget.carts.length,
            itemBuilder: (context, index) {
              final cart = widget.carts[index];
              final batteryPct = cart.batteryPct?.toInt() ?? 0;
              return ViaCartListItem(
                name: cart.id,
                batteryPercent: batteryPct,
                statusColor: _getCartStatusColor(cart.status),
                showBattery: true,
                isSelected: widget.selectedCartId == cart.id,
                onTap: () => widget.onCartSelected(cart),
              );
            },
          ),
        ),

        // Expand hint
        GestureDetector(
          onTap: () => _snapToIndex(2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.expand_less, size: 16, color: ViaDesignTokens.textMuted),
                const SizedBox(width: 4),
                Text(
                  'Swipe up for filters',
                  style: TextStyle(
                    fontSize: 11,
                    color: ViaDesignTokens.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Full state: Cart list + filters/sort/actions
  Widget _buildFullContent() {
    return Column(
      children: [
        // Header with search
        Padding(
          padding: const EdgeInsets.all(ViaDesignTokens.spacingLg),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: ViaDesignTokens.surfaceTertiary,
                    borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
                    border: Border.all(color: ViaDesignTokens.borderPrimary),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search,
                          size: 18,
                          color: ViaDesignTokens.textMuted,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            color: ViaDesignTokens.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search carts...',
                            hintStyle: TextStyle(
                              color: ViaDesignTokens.textMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.filter_list, size: 20, color: ViaDesignTokens.textPrimary),
                onPressed: () {
                  // TODO: Show filter sheet
                },
                tooltip: 'Filters',
              ),
            ],
          ),
        ),

        Divider(height: 1, color: ViaDesignTokens.borderPrimary),

        // Cart list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(ViaDesignTokens.spacingLg),
            itemCount: widget.carts.length,
            itemBuilder: (context, index) {
              final cart = widget.carts[index];
              final batteryPct = cart.batteryPct?.toInt() ?? 0;
              return ViaCartListItem(
                name: cart.id,
                batteryPercent: batteryPct,
                statusColor: _getCartStatusColor(cart.status),
                showBattery: true,
                isSelected: widget.selectedCartId == cart.id,
                onTap: () => widget.onCartSelected(cart),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper methods
  Map<CartStatus, int> _getStatusCounts() {
    final counts = <CartStatus, int>{};
    for (final cart in widget.carts) {
      counts[cart.status] = (counts[cart.status] ?? 0) + 1;
    }
    return counts;
  }

  Color _getCartStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return ViaDesignTokens.statusActive;
      case CartStatus.idle:
        return ViaDesignTokens.statusIdle;
      case CartStatus.charging:
        return ViaDesignTokens.statusCharging;
      case CartStatus.maintenance:
        return ViaDesignTokens.statusMaintenance;
      case CartStatus.offline:
        return ViaDesignTokens.statusOffline;
    }
  }

  Color _getBatteryColor(int batteryPct) {
    if (batteryPct > 50) return ViaDesignTokens.statusActive;
    if (batteryPct > 20) return ViaDesignTokens.statusIdle;
    return ViaDesignTokens.alertCritical;
  }

  IconData _batteryIcon(int batteryPct) {
    if (batteryPct > 80) return Icons.battery_full;
    if (batteryPct > 50) return Icons.battery_5_bar;
    if (batteryPct > 20) return Icons.battery_3_bar;
    return Icons.battery_1_bar;
  }
}
