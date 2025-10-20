import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';
import 'custom_icons.dart';

/// Professional top navigation bar widget inspired by TOSS app design
class ProfessionalAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showMenuButton;
  final bool showNotificationButton;
  final int? notificationBadgeCount;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ProfessionalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.showMenuButton = false,
    this.showNotificationButton = false,
    this.notificationBadgeCount,
    this.onBackPressed,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignTokens.bgPrimary,
        border: Border(
          bottom: BorderSide(
            color:
                DesignTokens.borderPrimary, // Already updated to be more subtle
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingXs, // Tighter vertical padding
          ),
          child: Row(
            children: [
              // Leading widget or back button
              if (leading != null)
                leading!
              else if (showBackButton)
                _buildBackButton(context)
              else if (showMenuButton)
                _buildMenuButton(context)
              else
                const SizedBox(width: DesignTokens.iconMd),

              // Title (left-aligned)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: DesignTokens.spacingSm),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXl,
                      fontWeight: DesignTokens.fontWeightBold,
                      color: foregroundColor ?? DesignTokens.textPrimary,
                      letterSpacing:
                          DesignTokens.letterSpacingNormal, // Tighter tracking
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              // Notification button (if enabled)
              if (showNotificationButton) ...[
                const SizedBox(width: DesignTokens.spacingSm),
                _buildNotificationButton(context),
              ],

              // Actions (right-aligned)
              if (actions != null) ...[
                const SizedBox(width: DesignTokens.spacingSm),
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
      child: Icon(
        CustomIcons.back,
        size: CustomIcons.iconLg,
        color: DesignTokens.textPrimary,
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return GestureDetector(
      onTap: onMenuPressed,
      child: Icon(
        CustomIcons.menu,
        size: CustomIcons.iconLg,
        color: DesignTokens.textPrimary,
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      onTap: onNotificationPressed,
      child: Stack(
        children: [
          Icon(
            CustomIcons.alerts,
            size: CustomIcons.iconLg,
            color: DesignTokens.textPrimary,
          ),
          if (notificationBadgeCount != null && notificationBadgeCount! > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: DesignTokens.alertCritical,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  notificationBadgeCount.toString(),
                  style: const TextStyle(
                    color: DesignTokens.textPrimary,
                    fontSize: DesignTokens.fontSizeXs,
                    fontWeight: DesignTokens.fontWeightSemibold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

/// Modern action button for app bar - Clean design without borders
class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const AppBarActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.size = CustomIcons.iconLg,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: size + 16,
            height: size + 16,
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: size,
              color: iconColor ?? DesignTokens.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Professional section header
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingMd,
            vertical: DesignTokens.spacingSm,
          ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
              color: DesignTokens.textSecondary,
              letterSpacing: DesignTokens.letterSpacingWide,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Professional tab bar
class ProfessionalTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final Color? activeColor;
  final Color? inactiveColor;

  const ProfessionalTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap?.call(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? (activeColor ?? DesignTokens.statusActive)
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMd,
                      fontWeight: isSelected
                          ? DesignTokens.fontWeightSemibold
                          : DesignTokens.fontWeightMedium,
                      color: isSelected
                          ? (activeColor ?? DesignTokens.textPrimary)
                          : (inactiveColor ?? DesignTokens.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
