import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/theme/status_colors.dart';
import 'cart_list_item.dart';
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

class _CartListVerticalState extends State<CartListVertical> with SingleTickerProviderStateMixin {
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
    final stripWidth = 120.0;
    final bottomNavHeight = 56.0; // 하단 네비게이션 바 높이

    return Positioned(
      top: DesignTokens.spacingMd,
      bottom: bottomNavHeight + DesignTokens.spacingMd,
      left: widget.cartListOnRight ? null : DesignTokens.spacingMd,
      right: widget.cartListOnRight ? DesignTokens.spacingMd : null,
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
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car, size: 14),
                      const SizedBox(width: 8),
                      const Text('카트', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text('(${widget.carts.length})', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(.62))),
                      const Spacer(),
                      IconButton(
                        tooltip: widget.isCollapsed ? '패널 펼치기' : '패널 접기',
                        iconSize: 16,
                        onPressed: widget.onToggleCollapse,
                        icon: Icon(widget.isCollapsed ? Icons.unfold_more : Icons.unfold_less),
                        splashRadius: 18,
                      ),
                    ],
                  ),
                ),
                // 구분선 (고정)
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                // 리스트 (애니메이션)
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final itemHeight = 36.0;
                    final padding = 8.0;
                    final listHeight = (widget.carts.length * itemHeight) + padding;
                    
                    return Container(
                      height: _animationController.value * listHeight,
                      child: ClipRect(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: widget.carts.length,
                          itemBuilder: (context, index) {
                            final cart = widget.carts[index];
                            final batteryPct = cart.batteryPct?.toInt() ?? 0;
                            final isCharging = cart.status == CartStatus.charging;
                              return CartListItem(
                                name: cart.id,
                                batteryPercent: batteryPct,
                                statusColor: _getCartStatusColor(cart.status),
                                showBattery: isCharging || batteryPct <= 30,
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
        return StatusColors.active;
      case CartStatus.idle:
        return StatusColors.idle;
      case CartStatus.charging:
        return StatusColors.idle; // Use same as idle for charging
      case CartStatus.maintenance:
        return StatusColors.maint;
      case CartStatus.offline:
        return StatusColors.offline;
      default:
        return Colors.grey;
    }
  }

  Color _getBatteryColor(double? batteryPct) {
    if (batteryPct == null) return Colors.grey;
    if (batteryPct > 50) return Colors.green;
    if (batteryPct > 20) return Colors.orange;
    return Colors.red;
  }
}

