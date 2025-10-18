import 'package:flutter/material.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/work_order.dart';
import '../theme/design_tokens.dart';

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
    final color = DesignTokens.getStatusColor(status.name);
    final text = status.displayName;

    return Container(
      decoration: BoxDecoration(
        color: DesignTokens.bgTertiary,
        borderRadius: BorderRadius.circular(
          isCompact ? DesignTokens.radiusSm : DesignTokens.radiusMd,
        ),
        border: Border.all(
          color: DesignTokens.borderPrimary,
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          // Colored left border
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  isCompact ? DesignTokens.radiusSm : DesignTokens.radiusMd,
                ),
                border: Border(
                  left: BorderSide(
                    color: color,
                    width: 3.0,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  isCompact ? DesignTokens.spacingSm : DesignTokens.spacingMd,
              vertical:
                  isCompact ? DesignTokens.spacingXs : DesignTokens.spacingXs,
            ),
            child: Text(
              text.toUpperCase(),
              style: DesignTokens.getUppercaseLabelStyle(
                fontSize: isCompact
                    ? DesignTokens.fontSizeXs
                    : DesignTokens.fontSizeSm,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: color,
              ),
            ),
          ),
        ],
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
    final color = DesignTokens.getPriorityColor(priority.name);
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
          const SizedBox(width: DesignTokens.spacingSm),
          Text(
            text.toUpperCase(),
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: color,
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
        color: DesignTokens.alertCritical,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: DesignTokens.textPrimary,
            fontSize: size * 0.5,
            fontWeight: DesignTokens.fontWeightSemibold,
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
    final displayColor = color ?? DesignTokens.textPrimary;

    return Container(
      padding: EdgeInsets.all(
          isCompact ? DesignTokens.spacingSm : DesignTokens.spacingMd),
      decoration: DesignTokens.getCardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize:
                  isCompact ? DesignTokens.fontSizeXs : DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightMedium,
              color: DesignTokens.textSecondary,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: displayColor,
                  fontSize: isCompact
                      ? DesignTokens.fontSizeLg
                      : DesignTokens.fontSizeXl,
                  fontWeight: DesignTokens.fontWeightBold,
                ),
              ),
              const SizedBox(width: DesignTokens.spacingXs),
              Text(
                unit,
                style: TextStyle(
                  color: displayColor.withValues(alpha: 0.7),
                  fontSize: isCompact
                      ? DesignTokens.fontSizeXs
                      : DesignTokens.fontSizeSm,
                  fontWeight: DesignTokens.fontWeightMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
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
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (widget.type) {
      case ActionButtonType.primary:
        backgroundColor = DesignTokens.textPrimary;
        foregroundColor = DesignTokens.bgPrimary;
        break;
      case ActionButtonType.secondary:
        backgroundColor = Colors.transparent;
        foregroundColor = DesignTokens.textPrimary;
        borderColor = DesignTokens.borderSecondary;
        break;
      case ActionButtonType.destructive:
        backgroundColor = DesignTokens.alertCritical;
        foregroundColor = DesignTokens.textPrimary;
        break;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    _animationController.forward().then((_) {
                      _animationController.reverse();
                    });
                    widget.onPressed?.call();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              elevation: DesignTokens.elevationNone,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                side: borderColor != null
                    ? BorderSide(color: borderColor)
                    : BorderSide.none,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingLg,
                vertical: DesignTokens.spacingMd,
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: DesignTokens.iconSm,
                    height: DesignTokens.iconSm,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.type == ActionButtonType.primary
                            ? DesignTokens.bgPrimary
                            : DesignTokens.textPrimary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: DesignTokens.iconSm),
                        const SizedBox(width: DesignTokens.spacingSm),
                      ],
                      Text(
                        widget.text.toUpperCase(),
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          letterSpacing: DesignTokens.letterSpacingWide,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

enum ActionButtonType {
  primary,
  secondary,
  destructive,
}

/// Base modal widget with slide-up animation
class BaseModal extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;

  const BaseModal({
    super.key,
    required this.child,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: DesignTokens.bgTertiary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(DesignTokens.radiusLg),
          topRight: Radius.circular(DesignTokens.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: DesignTokens.spacingSm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: DesignTokens.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.all(DesignTokens.spacingLg),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSizeXl,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ],

          // Content
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// Status bar widget for displaying cart counts
class StatusBar extends StatelessWidget {
  final Map<String, int> statusCounts;
  final VoidCallback? onTap;

  const StatusBar({
    super.key,
    required this.statusCounts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary,
        border: Border(
          top: BorderSide(color: DesignTokens.borderPrimary),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusItem(
              'TOTAL', statusCounts['total'] ?? 0, DesignTokens.textPrimary),
          _buildStatusItem(
              'ACTIVE', statusCounts['active'] ?? 0, DesignTokens.statusActive),
          _buildStatusItem('SERVICE', statusCounts['maintenance'] ?? 0,
              DesignTokens.statusMaintenance),
          _buildStatusItem('CHARGING', statusCounts['charging'] ?? 0,
              DesignTokens.statusCharging),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, int count, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: DesignTokens.fontSizeLg,
              fontWeight: DesignTokens.fontWeightBold,
              color: color,
            ),
          ),
          const SizedBox(height: DesignTokens.spacingXs),
          Text(
            label,
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize: DesignTokens.fontSizeXs,
              color: DesignTokens.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Progress indicator with steps
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? DesignTokens.statusActive
                            : DesignTokens.borderPrimary,
                      ),
                    ),
                  ),
                  if (index < totalSteps - 1)
                    const SizedBox(
                      width: 2,
                      height: 2,
                    ),
                ],
              ),
            );
          }),
        ),
        if (stepLabels != null) ...[
          const SizedBox(height: DesignTokens.spacingSm),
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              final label = stepLabels![index];

              return Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: DesignTokens.getUppercaseLabelStyle(
                    fontSize: DesignTokens.fontSizeXs,
                    color: isActive
                        ? DesignTokens.textPrimary
                        : DesignTokens.textTertiary,
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// Glass morphism search bar
class GlassSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;

  const GlassSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: DesignTokens.getGlassMorphismDecoration(),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: DesignTokens.textPrimary,
          fontSize: DesignTokens.fontSizeMd,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: DesignTokens.textTertiary,
            fontSize: DesignTokens.fontSizeMd,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: DesignTokens.textSecondary,
            size: DesignTokens.iconMd,
          ),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: DesignTokens.textSecondary,
                    size: DesignTokens.iconMd,
                  ),
                  onPressed: onFilterTap,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingMd,
          ),
        ),
      ),
    );
  }
}
