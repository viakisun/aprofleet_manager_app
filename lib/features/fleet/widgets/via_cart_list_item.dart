import 'package:flutter/material.dart';

/// VIA Design System Cart List Item
///
/// Premium card-style cart item matching reference HTML design
class ViaCartListItem extends StatefulWidget {
  final String name;
  final int batteryPercent;
  final Color statusColor;
  final bool showBattery;
  final bool isSelected;
  final VoidCallback? onTap;

  const ViaCartListItem({
    super.key,
    required this.name,
    required this.batteryPercent,
    required this.statusColor,
    this.showBattery = true,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ViaCartListItem> createState() => _ViaCartListItemState();
}

class _ViaCartListItemState extends State<ViaCartListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  Color _getBatteryColor() {
    if (widget.batteryPercent > 50) {
      return const Color(0xFF00C97B); // Green
    } else if (widget.batteryPercent > 20) {
      return const Color(0xFFD67500); // Orange
    } else {
      return const Color(0xFFD14B4B); // Red
    }
  }

  IconData _batteryIcon(int percent) {
    if (percent >= 95) return Icons.battery_full_rounded;
    if (percent >= 75) return Icons.battery_6_bar_rounded;
    if (percent >= 50) return Icons.battery_5_bar_rounded;
    if (percent >= 30) return Icons.battery_3_bar_rounded;
    if (percent > 10) return Icons.battery_2_bar_rounded;
    return Icons.battery_alert_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final batteryColor = _getBatteryColor();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFF00C97B).withValues(alpha: 0.12)
                : const Color(0xFF181818),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF00C97B).withValues(alpha: 0.5)
                  : const Color(0xFF1E1E1E),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              // Status indicator - circular with glow
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: widget.statusColor,
                  shape: BoxShape.circle,
                  boxShadow: _shouldGlow(widget.statusColor)
                      ? [
                          BoxShadow(
                            color: widget.statusColor.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
              ),

              const SizedBox(width: 10),

              // Cart info
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cart ID
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                        letterSpacing: 0,
                        height: 1.3,
                      ),
                    ),

                    // Battery indicator
                    if (widget.showBattery)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _batteryIcon(widget.batteryPercent),
                            size: 16,
                            color: batteryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.batteryPercent}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: batteryColor,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldGlow(Color statusColor) {
    // Glow for active (green) and charging (blue) states
    return statusColor == const Color(0xFF00C97B) || // Active green
        statusColor == const Color(0xFF3B83CC); // Charging blue
  }
}
