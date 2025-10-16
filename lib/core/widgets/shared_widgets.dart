import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../domain/models/cart.dart';
import '../domain/models/work_order.dart';
import '../domain/models/alert.dart';

class CartStatusChip extends StatelessWidget {
  final CartStatus status;
  final bool isCompact;

  const CartStatusChip({
    super.key,
    required this.status,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.statusColors[status] ?? Colors.grey;
    final text = status.displayName;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: isCompact ? 10 : 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class PriorityIndicator extends StatelessWidget {
  final Priority priority;
  final bool showText;

  const PriorityIndicator({
    super.key,
    required this.priority,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppConstants.priorityColors[priority] ?? Colors.grey;
    final text = priority.displayName;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

class AlertBadge extends StatelessWidget {
  final int count;
  final double size;

  const AlertBadge({
    super.key,
    required this.count,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEF4444),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class TelemetryWidget extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color? color;
  final bool isCompact;

  const TelemetryWidget({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? Colors.white;

    return Container(
      padding: EdgeInsets.all(isCompact ? 8 : 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: isCompact ? 10 : 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: displayColor,
                  fontSize: isCompact ? 16 : 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  color: displayColor.withOpacity(0.7),
                  fontSize: isCompact ? 10 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ActionButtonType type;
  final bool isLoading;
  final IconData? icon;

  const ActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ActionButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    switch (type) {
      case ActionButtonType.primary:
        backgroundColor = Colors.white;
        foregroundColor = Colors.black;
        break;
      case ActionButtonType.secondary:
        backgroundColor = Colors.transparent;
        foregroundColor = Colors.white;
        break;
      case ActionButtonType.destructive:
        backgroundColor = const Color(0xFFEF4444);
        foregroundColor = Colors.white;
        break;
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: type == ActionButtonType.secondary
              ? BorderSide(color: Colors.white.withOpacity(0.2))
              : BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );
  }
}

enum ActionButtonType {
  primary,
  secondary,
  destructive,
}
