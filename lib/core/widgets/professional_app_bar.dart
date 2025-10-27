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
        boxShadow: [
          // iOS-style subtle shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.04), // Ultra-thin subtle border
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0, // More generous (was 16)
            vertical: 12.0, // More generous (was 8)
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

              // Title (left-aligned, iOS-style typography)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: DesignTokens.spacingMd),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXl,
                      fontWeight: FontWeight.w600, // iOS SF Pro semibold
                      color: foregroundColor ?? DesignTokens.textPrimary,
                      letterSpacing: -0.5, // iOS-style tighter tracking
                      height: 1.2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              // Notification button (if enabled)
              if (showNotificationButton) ...[
                const SizedBox(width: DesignTokens.spacingMd), // More generous spacing
                _buildNotificationButton(context),
              ],

              // Actions (right-aligned)
              if (actions != null) ...[
                const SizedBox(width: DesignTokens.spacingMd), // More generous spacing
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Modern iOS-style back button with proper touch area and ripple
  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.06), // Subtle background
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onBackPressed ?? () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          width: 48,  // Minimum touch area (accessibility)
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            CustomIcons.back,
            size: 24, // Standard icon size
            color: DesignTokens.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Modern iOS-style menu button with proper touch area and ripple
  Widget _buildMenuButton(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.06), // Subtle background
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onMenuPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          width: 48,  // Minimum touch area (accessibility)
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            CustomIcons.menu,
            size: 24, // Standard icon size
            color: DesignTokens.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Modern iOS-style notification button with badge and proper touch area
  Widget _buildNotificationButton(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.06), // Subtle background
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onNotificationPressed,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          width: 48,  // Minimum touch area (accessibility)
          height: 48,
          alignment: Alignment.center,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                CustomIcons.alerts,
                size: 24, // Standard icon size
                color: DesignTokens.textPrimary,
              ),
              if (notificationBadgeCount != null && notificationBadgeCount! > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: DesignTokens.alertCritical,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: DesignTokens.bgPrimary,
                        width: 1.5,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      notificationBadgeCount! > 99 ? '99+' : notificationBadgeCount.toString(),
                      style: const TextStyle(
                        color: DesignTokens.textPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
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
