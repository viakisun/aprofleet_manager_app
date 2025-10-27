import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/theme/status_colors.dart';
import '../../../core/utils/performance_logger.dart';
import 'via_cart_list_item.dart';
import '../../../domain/models/cart.dart';

class CartListVertical extends StatefulWidget {
  final List<Cart> carts;
  final String? selectedCartId;
  final bool compactDensity;
  final bool cartListOnRight;
  final bool isCollapsed;
  final Function(Cart) onCartSelected;
  final VoidCallback onToggleCollapse;

  const CartListVertical({
    super.key,
    required this.carts,
    required this.selectedCartId,
    required this.compactDensity,
    required this.cartListOnRight,
    required this.isCollapsed,
    required this.onCartSelected,
    required this.onToggleCollapse,
  });

  @override
  State<CartListVertical> createState() => _CartListVerticalState();
}

class _CartListVerticalState extends State<CartListVertical>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: widget.isCollapsed ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(CartListVertical oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceLogger.start('CartListVertical.build');

    const stripWidth = 180.0; // Increased width for card design
    const bottomNavHeight = 56.0; // 하단 네비게이션 바 높이

    final result = Positioned(
      top: IndustrialDarkTokens.spacingItem,
      bottom: bottomNavHeight + IndustrialDarkTokens.spacingItem,
      left: widget.cartListOnRight ? null : IndustrialDarkTokens.spacingItem,
      right: widget.cartListOnRight ? IndustrialDarkTokens.spacingItem : null,
      child: SizedBox(
        width: stripWidth,
        child: IntrinsicHeight(
          child: GlassPanel(
            bgOpacity: 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min, // 핵심: 내용에 맞게 크기 조정
              children: [
                // 헤더 (고정)
                Container(
                  height: 40,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Row(
                          children: [
                            const Text('CARTS',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3)),
                            const SizedBox(width: 4),
                            Text('${widget.carts.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(.5),
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: widget.isCollapsed ? '펼치기' : '접기',
                        iconSize: 16,
                        onPressed: widget.onToggleCollapse,
                        icon: Icon(widget.isCollapsed
                            ? Icons.unfold_more
                            : Icons.unfold_less),
                        splashRadius: 16,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 28, minHeight: 28),
                      ),
                    ],
                  ),
                ),
                // 구분선 (고정)
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                // 리스트 (애니메이션)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    // Each cart item: 13px padding top + 13px padding bottom + content (~16px) + 8px margin = ~50px
                    const itemHeight = 50.0;
                    const topPadding = 12.0;
                    const bottomPadding = 8.0;
                    final listHeight = (widget.carts.length * itemHeight) +
                        topPadding +
                        bottomPadding;

                    return SizedBox(
                      height: _animationController.value * listHeight,
                      child: ClipRect(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 12, bottom: 8),
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.carts.length,
                          itemBuilder: (context, index) {
                            final cart = widget.carts[index];
                            final batteryPct = cart.batteryPct?.toInt() ?? 0;
                            return ViaCartListItem(
                              name: cart.id,
                              batteryPercent: batteryPct,
                              statusColor: _getCartStatusColor(cart.status),
                              showBattery:
                                  true, // Always show battery like reference
                              isSelected: widget.selectedCartId == cart.id,
                              onTap: () => widget.onCartSelected(cart),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    PerformanceLogger.end('CartListVertical.build');
    return result;
  }

  IconData _getCartStatusIcon(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return LucideIcons.playCircle;
      case CartStatus.idle:
        return LucideIcons.pauseCircle;
      case CartStatus.charging:
        return LucideIcons.batteryCharging;
      case CartStatus.maintenance:
        return LucideIcons.wrench;
      case CartStatus.offline:
        return LucideIcons.wifiOff;
      default:
        return LucideIcons.helpCircle;
    }
  }

  Color _getCartStatusColor(CartStatus status) {
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

  Color _getBatteryColor(double? batteryPct) {
    if (batteryPct == null) return Colors.grey;
    if (batteryPct > 50) return Colors.green;
    if (batteryPct > 20) return Colors.orange;
    return Colors.red;
  }
}
