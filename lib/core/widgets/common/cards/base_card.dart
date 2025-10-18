import 'package:flutter/material.dart';
import '../../../theme/design_tokens.dart';

/// A reusable base card widget with consistent styling
class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final VoidCallback? onTap;
  final bool isElevated;

  const BaseCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.onTap,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: backgroundColor ?? DesignTokens.bgTertiary,
      borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusMd),
      border: border ?? Border.all(
        color: Colors.white.withValues(alpha: 0.06),
        width: 1,
      ),
      boxShadow: isElevated ? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ] : null,
    );

    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(DesignTokens.spacingMd),
      decoration: cardDecoration,
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusMd),
        child: cardContent,
      );
    }

    if (margin != null) {
      cardContent = Container(
        margin: margin,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// A specialized card for displaying information with header
class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.content,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      padding: padding,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: DesignTokens.spacingSm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSizeMd,
                        fontWeight: DesignTokens.fontWeightSemibold,
                        color: DesignTokens.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: DesignTokens.spacingXs),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          // Content
          if (content != null) ...[
            const SizedBox(height: DesignTokens.spacingMd),
            content!,
          ],
        ],
      ),
    );
  }
}

/// A specialized card for displaying status information
class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final Color? valueColor;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.valueColor,
    this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: DesignTokens.iconSm,
                  color: DesignTokens.textSecondary,
                ),
                const SizedBox(width: DesignTokens.spacingSm),
              ],
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: DesignTokens.getUppercaseLabelStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: DesignTokens.spacingSm),
          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeXl,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: valueColor ?? DesignTokens.textPrimary,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: DesignTokens.spacingXs),
                Text(
                  unit!,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: (valueColor ?? DesignTokens.textPrimary).withValues(alpha: 0.7),
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
